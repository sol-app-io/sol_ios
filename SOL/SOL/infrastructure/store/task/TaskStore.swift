//
//  TaskStore.swift
//  SOL
//
//  Created by Rostislav Maslov on 08.09.2021.
//

import Foundation
import Combine

public class TaskStore: ObservableObject {
    @Published var tasks:[String: TaskEntity] = [String: TaskEntity]()
    /// Depricated
    @Published var forNotifyCombine = UUID()
    
    //тут сделать tasksForViewWithSort
    
    var spaceStore: SpaceStore?
    var slotStore: SlotStore?
    var viewUserStore: ViewUserStore?
    
    private var disposables = Set<AnyCancellable>()
    private let port:TaskRepositoryPort = SolApiService.api().task        
}

//MARK: - Загрузка
extension TaskStore {
    func addLazyTask(taskId: String){
        if tasks[taskId] == nil {
            //TODO: -
            tasks[taskId] = TaskEntity()
            tasks[taskId]!.id = taskId
        }
    }
    
    func sync() {
        SolPublisher<[TaskEntity], Bool>(useCase: TaskAllUseCase(self.port))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] publisherReponse in
                if publisherReponse.success != nil {
                    let tasks = publisherReponse.success!
                    for task in tasks {
                        if self?.tasks[task.id] == nil {
                            self?.tasks[task.id] = task
                        }
                    }
                }else {
                }
            }
            .store(in: &disposables)
    }
    
    func syncTask(taskId: String, silent: Bool = false){
        if tasks[taskId] == nil {
            //TODO: - 
            tasks[taskId] = TaskEntity()
            tasks[taskId]!.id = taskId
        }
        SolPublisher<TaskEntity, Bool>(useCase: TaskUseCase(self.port, TaskUseCase.Input.of(taskId)))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] publisherReponse in
                if publisherReponse.success != nil {
                    let task = publisherReponse.success!
                    task.showSubtask = self!.tasks[taskId]!.showSubtask
                    for child in task.child {
                        self?.syncTask(taskId: child.id)
                    }
                    self?.tasks[taskId] = task
                    self?.tasks[task.id]?.loadStatus = LoadStatus.SUCCESS
                    
                    if silent == false {
                        self?.tasks[taskId]!.lastUpdateUUID = UUID()
                    } 
                }else {
                }
                               
            }
            .store(in: &disposables)
    }
}

//MARK: - Изменение
extension TaskStore {
    
    func toggle(taskId : String){
        tasks[taskId]!.showSubtask = !tasks[taskId]!.showSubtask
    }
    
    func toggleByParentTask(parentTaskId : String, show: Bool){
        for key in tasks.keys {
            if tasks[key]?.parentTaskId == parentTaskId {
                tasks[key]?.showSubtask = show
            }
        }
    }
    
    func toggleBySpaceId(spaceId : String, show: Bool){
        for task in spaceStore!.spaces[spaceId]!.tasks {
            if tasks[task.id]?.spaceId == spaceId {
                tasks[task.id]?.showSubtask = show
            }
        }
    }
    
    func toggleByViewId(viewId : String, show: Bool){
        if viewUserStore!.byView[viewId] == nil {
            return
        }
        
        for viewUser:TaskInViewResponse in viewUserStore!.byView[viewId]! {
            if tasks[viewUser.taskId!] != nil {
                tasks[viewUser.taskId!]?.showSubtask = show
            }
        }
    }
    
    func changeStatus(taskId: String){
        let task:TaskEntity = tasks[taskId]!
        
        if (task.status == TaskStatus.DONE) {
            tasks[taskId]!.status = TaskStatus.OPEN
            SolPublisher<TaskEntity, Bool>(useCase: MakeTaskOpenUseCase(self.port, MakeTaskOpenUseCase.Input.of(task.id)))
                .receive(on: DispatchQueue.main)
                .sink { [weak self] publisherReponse in
                    if publisherReponse.success != nil {
                        self?.tasks[taskId]!.status = publisherReponse.success!.status
                    }else {
                    }
                    // self?.tasks[taskId]!.lastUpdateUUID = UUID()
                    self?.spaceStore?.spaces[task.spaceId!]!.countTask = (self?.spaceStore!.spaces[task.spaceId!]!.countTask)! + 1
                }
                .store(in: &disposables)
        } else if (task.status == TaskStatus.OPEN) {
            tasks[taskId]!.status = TaskStatus.DONE
            SolPublisher<TaskEntity, Bool>(useCase: MakeTaskDoneUseCase(self.port, MakeTaskDoneUseCase.Input.of(task.id)))
                .receive(on: DispatchQueue.main)
                .sink { [weak self] publisherReponse in
                    if publisherReponse.success != nil {
                        self?.tasks[taskId]!.status = publisherReponse.success!.status
                    }else {
                    }
                    // self?.tasks[taskId]!.lastUpdateUUID = UUID()
                    self?.spaceStore?.spaces[task.spaceId!]!.countTask = (self?.spaceStore!.spaces[task.spaceId!]!.countTask)! - 1
                }
                .store(in: &disposables)
        }
        
        // NOTE: - Обновляем ласт апдейт что бы вю узнало об обновлении
        tasks[taskId]!.lastUpdateUUID = UUID()
        self.forNotifyCombine = UUID()
    }
    
    func saveTitleIcon(taskId: String) {
        saveTitleIcon(taskId: taskId, title: tasks[taskId]!.title, iconData: tasks[taskId]!.icon.data)        
    }
    
    func saveTitleIcon(taskId: String, title: String, iconData: String) {
        tasks[taskId]?.title = title
        tasks[taskId]?.icon.data = iconData
        
        SolPublisher<TaskEntity, Bool>(
            useCase: EditTitleAndIconTaskUseCase(
                self.port,
                EditTitleAndIconTaskUseCase.Input.of(taskId, title, iconData)))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] publisherReponse in
                if publisherReponse.success != nil {
                }else {                    
                }
                self?.tasks[taskId]!.lastUpdateUUID = UUID()
            }
            .store(in: &disposables)
    }
}

//MARK: - СОРТИРОВКА
extension TaskStore {
    func reorderTasks(parentTaskId:String, draggetTaskId: String, dropOnTaskId: String) -> Bool{
        var taskList:[TaskEntity] = []
        let taskParentCandidate:TaskEntity? = tasks[parentTaskId]
        if taskParentCandidate != nil {
            taskList = taskParentCandidate!.child
        }else{
            let spaceCandidate: SpaceEntity? = spaceStore?.spaces[parentTaskId]
            if spaceCandidate != nil {
                taskList = spaceCandidate!.tasks
            }
        }
        
        
        if (draggetTaskId == dropOnTaskId) {
            return false
        }
        
        var draggetTaskIndex: Int? = nil
        for index in 0...(taskList.count - 1) {
            if (taskList[index].id == draggetTaskId) {
                draggetTaskIndex = index
            }
        }
        if draggetTaskIndex == nil  {
            return false
        }
        let taskToChange = taskList.remove(at: draggetTaskIndex!)
        
        var dropOnTaskIndex: Int? = nil
        for index in 0...(taskList.count - 1) {
            if (taskList[index].id == dropOnTaskId) {
                dropOnTaskIndex = index
            }
        }
        if  dropOnTaskIndex == nil {
            return false
        }
        
        taskList.insert(taskToChange, at: dropOnTaskIndex!)
        var toCommint:[String] = []
        for ttt in taskList {
            toCommint.append(ttt.id)
        }
        
        if taskParentCandidate != nil {
            taskParentCandidate?.lastUpdateUUID = UUID()
        }
        
        commitNewSort(tasksToSort: toCommint)
        return true
    }
    
    func moveTaskToEnd(parentTaskId: String, draggetTaskId: String) -> Bool{
        let task:TaskEntity = tasks[parentTaskId]!
        if (draggetTaskId == task.child[task.child.count - 1].id) {
            return false
        }
        
        var draggetTaskIndex: Int? = nil
        for index in 0...(task.child.count - 1) {
            if (task.child[index].id == draggetTaskId) {
                draggetTaskIndex = index
            }
        }
        if draggetTaskIndex == nil  {
            return false
        }
        let taskToChange = task.child.remove(at: draggetTaskIndex!)
        task.child.insert(taskToChange, at: task.child.endIndex)
        var toCommint:[String] = []
        for ttt in task.child {
            toCommint.append(ttt.id)
        }
        commitNewSort(tasksToSort: toCommint)
        return true
    }
    
    private func commitNewSort(tasksToSort:[String]){
        SolPublisher<[TaskEntity], Bool>(useCase: ChangeSortTaskUseCase(self.port, ChangeSortTaskUseCase.Input.init(tasks: tasksToSort)))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] publisherReponse in
                if publisherReponse.success != nil {
                    for taskId in tasksToSort {
                        self?.syncTask(taskId: taskId)
                    }
                }else {
                }
            }
            .store(in: &disposables)
    }
}

//MARK: - Создание таска
extension TaskStore {
    func create( title: String,
                 emoji: String,
                 parentTaskId: String?,
                 spaceId: String?,
                 deadline: Date?,
                 deadlineType: DeadlineType?,
                 timezone: Int?,
                 slots: [SlotEntity]){
        SolPublisher<TaskEntity, Bool>(useCase:
                                        CreateTaskUseCase(self.port,
                                                          CreateTaskUseCase.Input.init(
                                                            title: title,
                                                            emoji: emoji,
                                                            parentTaskId: parentTaskId,
                                                            spaceId: spaceId,
                                                            deadline: deadline,
                                                            deadlineType: deadlineType,
                                                            timezone: timezone)))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                if(result.success != nil) {
                    let task = result.success!
                    self?.tasks[task.id] = task
                    
                    self?.createSlots(task: task, slots: slots)
                    
                    self?.tasks[task.id]?.loadStatus = LoadStatus.SUCCESS
                    if parentTaskId != nil {
                        self?.tasks[parentTaskId!]?.child.append(task)
                    }
                    if spaceId != nil {
                        self?.spaceStore?.spaces[spaceId!]!.tasks.append(task)
                        self?.spaceStore?.spaces[spaceId!]!.lastUpdateUUID = UUID()
                    }
                    
                    if parentTaskId != nil && self?.tasks[parentTaskId!] != nil {
                        self?.tasks[parentTaskId!]!.lastUpdateUUID = UUID()
                    }
                    if self?.spaceStore?.spaces[task.spaceId!] != nil {
                        self?.spaceStore?.spaces[task.spaceId!]!.countTask = (self?.spaceStore!.spaces[task.spaceId!]!.countTask)! + 1
                        self?.spaceStore?.spaces[task.spaceId!]?.lastUpdateUUID = UUID()
                    }
                    self?.forNotifyCombine = UUID()
                }
            }
            .store(in: &disposables)
    }
    
    func createSlots(task: TaskEntity, slots: [SlotEntity]) {
        for slot in slots {
           slotStore?.create(startTime: slot.startTime!, endTime: slot.endTime!, taskId: task.id)
        }
    }
}

