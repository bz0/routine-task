import React, {useState, useEffect, useRef} from 'react';
import {
  Flex,
  FormControl,
  FormLabel,
  List,
  Input,Button
} from '@chakra-ui/react';
import { TaskRow } from '../components/TaskRow'
import { getTaskList, createTask, validate } from '../models/task'

export const Home = () => {
    const [tasks, setTask] = useState({})
    const addTaskRef = useRef(null)

    useEffect(() => {
      getList()
    }, [])

    const getList = async () => {
      const body = await getTaskList()
      console.log("body:", body)
      setTask(body.data)
    };
    
    const create = async (e) => {
      if (!addTaskRef.current.value) {
          alert("タスク名が未入力です")
          return ;
      }

      const result = await createTask(addTaskRef.current.value)
      if(validate(result)){
        getList()
      }
    }

    return (
        <>
          <FormControl mt={5}>
            <FormLabel fontWeight="bold">タスクを追加する</FormLabel>
            <Flex>
              <Input ref={addTaskRef} />
              <Button variant="solid" size="md" ml={5} onClick={create}>
                追加
              </Button>
            </Flex>
          </FormControl>

          <List mt={10}>
            {tasks.length > 0 && tasks.map((task, index) =>
              <TaskRow task={task} getList={getList} index={index} key={index} />
            )}
          </List>
        </>
    )
}