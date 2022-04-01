import React, {useState, useEffect, useRef} from 'react';
import {
  Flex,
  FormControl,
  FormLabel,
  List,
  Input,Button
} from '@chakra-ui/react';
import { TaskRow } from '../components/TaskRow'
import { getTaskList, createTask } from '../models/task'

export const Home = () => {
    const [tasks, setTask] = useState({})
    const taskRef = useRef(null)

    useEffect(() => {
      getList()
    }, [])

    const getList = async () => {
      // countに応じてアクセスするAPIを変えなければならない
      const body = await getTaskList()
      setTask(body.data)
    };

    const create = async (e) => {
        if (!taskRef.current.value) {
            alert("タスク名が未入力です")
            return ;
        }

        await createTask(taskRef.current.value)
        getList()
    }

    return (
        <>
          <FormControl mt={5}>
            <FormLabel fontWeight="bold">タスクを追加する</FormLabel>
            <Flex>
              <Input ref={taskRef} />
              <Button variant="solid" size="md" ml={5} onClick={create}>
                追加
              </Button>
            </Flex>
          </FormControl>

          <List mt={10}>
            {tasks.length > 0 && tasks.map((task, index) =>
              <TaskRow task={task} index={index} key={index} />
            )}
          </List>
        </>
    )
}