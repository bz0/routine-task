import React, {useState, useEffect, useRef} from 'react';
import {
  Flex,
  FormControl,
  FormLabel,
  List,
  Box,
  Input,Button,
  InputGroup,
  InputLeftElement,
  Text,
  Alert,AlertIcon
} from '@chakra-ui/react';
import { IoMdSearch } from 'react-icons/io';
import { TaskRow } from '../components/TaskRow'
import { getTaskList, createTask, validate } from '../models/task'

export const Home = () => {
    const [tasks, setTask] = useState({})
    const addTaskRef = useRef(null)
    const searchRef = useRef(null)

    useEffect(() => {
      getList()
    }, [])

    const getList = async () => {
      let params = {}
      if (searchRef.current.value){
        params = {keyword: searchRef.current.value}
      }
      const body = await getTaskList(params)
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

    const search = async () => {
      getList()
    }

    return (
        <>
          <FormControl mt={5}>
            <FormLabel fontWeight="bold">タスクを追加する</FormLabel>
            <Flex>
              <Input ref={addTaskRef} focusBorderColor='pink.500' />
              <Button variant="solid" size="md" ml={5} onClick={create} colorScheme='pink'>
                追加
              </Button>
            </Flex>
          </FormControl>

          <Flex mt={10} justifyContent="flex-end">
            <Box w={{base:"100%", md:"40%"}}>
              <InputGroup>
                <InputLeftElement
                  pointerEvents='none'
                  children={<IoMdSearch />}
                />
                <Input type='text' ref={searchRef} placeholder='検索ワードを入力'  focusBorderColor='pink.500' onChange={search} />
              </InputGroup>
            </Box>
            <Box my='auto' display='flex' ml='5' mr='3'>
              <Text my="auto">全</Text>
              <Text mx="2" my="auto" fontSize='2xl' fontWeight='bold' color='pink.500' data-testid="count">{tasks.length}</Text>
              <Text my="auto">件</Text>
            </Box>
          </Flex>
          <List mt={2}>
            {tasks.length > 0 ? tasks.map((task, index) =>
              <TaskRow task={task} getList={getList} index={index} key={task.id} data-testid="tasks" />
            ) :   <Alert status='error' mt='10' variant='left-accent'>
                    <AlertIcon /> タスクがありません。タスクを追加して下さい
                  </Alert>}
          </List>
        </>
    )
}