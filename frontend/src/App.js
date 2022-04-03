import React from 'react';
import {
  ChakraProvider,
  Flex,
  theme,
  Heading,
  Box
} from '@chakra-ui/react';
import { Home } from './pages/Home'

import { MdOutlineChecklist } from 'react-icons/md';

function App() {
  return (
    <ChakraProvider theme={theme}>
        <Flex justifyContent="flex-start" align={{base:"center", md:"center"}} px={8} py={3} backgroundColor="#000000" color="whiteAlpha.800">
          <Heading size="sm" display="flex" m={{base:"auto", md:"0"}}>
            <Box><MdOutlineChecklist /></Box>
            <Box ml="3">習慣化タスクリマインダー</Box>
          </Heading>
        </Flex>

        <Box width={{base:"90%", md:"50%"}} m="auto" pb={10} minHeight="100%">
          <Home />
        </Box>
    </ChakraProvider>
  );
}

export default App;
