import React, {useState, useEffect, useRef} from 'react';
import { BiTask } from 'react-icons/bi';
import {
  Flex,
  FormControl,
  FormLabel,
  Box,List,
  Input,Button,ListItem,
  Spacer
} from '@chakra-ui/react';

export const Home = () => {
    const [tasks, setTask] = useState({})
    const taskRef = useRef(null)

    useEffect(() => {
        show();
    }, []);

    const url = 'http://' + process.env.REACT_APP_BACKEND_DOMAIN + '/tasks';
    const show = async () => {
      // countに応じてアクセスするAPIを変えなければならない
      console.log("url:",url)
      const response = await fetch(url,{
        headers: {
          Authorization: "Bearer " + process.env.REACT_APP_API_TOKEN
        }
      });
      const body = await response.json();
      console.log("body:", body)
      setTask(body.data); // stateに反映する
    };

    const create = async (e) => {
        if (!taskRef.current.value) {
            alert("タスク名が未入力です")
            return ;
        }

        await fetch(url,{
            method: 'POST',
            body : JSON.stringify({name: taskRef.current.value}),
            headers: {
              'Content-Type': 'application/json',
              Authorization: "Bearer " + process.env.REACT_APP_API_TOKEN
            }
        });

        show()
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
            {tasks.length > 0 && tasks.map((task, key) =>
              <ListItem border="1px solid #eee" mt={key>0 ? 5 : 0} px={8} py={3} display="block" key={key}>
                <Flex>
                  <Flex w='60%'>
                    <Box my='auto'><BiTask /></Box>
                    <Box ml='5' my='auto'>{task.name}</Box>  
                  </Flex>
                  <Spacer />
                  <Box>
                    <Button size='xs'>編集</Button>
                  </Box>
                  <Box>
                    <Button size='xs' ml='5' colorScheme='pink'>削除</Button>
                  </Box>
                </Flex>
              </ListItem>
            )}
          </List>
        </>
    )
}