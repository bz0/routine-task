import React, {useState, useEffect} from 'react';
import {
  ChakraProvider,
  Flex,
  theme,
  Heading,
  FormControl,
  FormLabel,
  Box,List,
  Input,Button,ListItem,
  Spacer
} from '@chakra-ui/react';
import { BiTask } from 'react-icons/bi';

function App() {
  const [tasks, setTask] = useState();
  useEffect(() => {
      create();
  });

  const create = async () => {
    // countに応じてアクセスするAPIを変えなければならない
    const url = 'http://' + process.env.REACT_APP_BACKEND_DOMAIN + '/tasks';
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

  return (
    <ChakraProvider theme={theme}>
        <Flex justifyContent="flex-start" px={8} py={3} backgroundColor="#000000" color="whiteAlpha.800">
          <Heading size="sm">習慣化タスクリマインダー</Heading>
        </Flex>

        <Box width="50%" m="auto" minHeight="100%">
          <FormControl mt={5}>
            <FormLabel fontWeight="bold">タスクを追加する</FormLabel>
            <Flex>
              <Input />
              <Button variant="solid" size="md" ml={5}>
                追加
              </Button>
            </Flex>
          </FormControl>

          <List mt={10}>
            {tasks && tasks.map((task, key) =>
              <ListItem border="1px solid #eee" px={8} py={3} display="block" key={key}>
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
        </Box>
    </ChakraProvider>
  );
}

export default App;
