import { Input } from '@chakra-ui/react'
import React from 'react';
import {
    InputGroup,
    Button
} from '@chakra-ui/react';

export const TaskAddForm = () => {
    return (
        <>
            <InputGroup size='md'>
                <Input
                    pr='4.5rem'
                    type='text'
                    placeholder=''
                />
                <Button h='1.75rem' height="auto" ml="2.5">追加</Button>
            </InputGroup>
        </>
    )
}
