import React from 'react';
import {
  ChakraProvider,
  Flex,
  theme,
  Heading,
  Box
} from '@chakra-ui/react';
import { Home } from './pages/Home'

function App() {
  return (
    <ChakraProvider theme={theme}>
        <Flex justifyContent="flex-start" px={8} py={3} backgroundColor="#000000" color="whiteAlpha.800">
          <Heading size="sm">習慣化タスクリマインダー</Heading>
        </Flex>

        <Box width="50%" m="auto" pb={10} minHeight="100%">
          <Home />
        </Box>
    </ChakraProvider>
  );
}

export default App;
