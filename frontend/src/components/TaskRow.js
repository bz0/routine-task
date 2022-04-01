import React, { useState,useEffect,useRef } from 'react';
import {
    ListItem,
    Box,
    Spacer,
    Flex,
    Button,
    Input
} from '@chakra-ui/react';
import { BiTask } from 'react-icons/bi';
import { updateTask } from '../models/task'
import moment from 'moment'

export const TaskRow = (props) => {
    const [isEdit, setIsEdit] = useState(false)
    const taskRef = useRef(props.task.name)

    useEffect(() => {}, [isEdit])

    //編集エリアを表示
    const handleIsEdit = () => {
        setIsEdit(true)
    }

    //タスク情報の表示
    const handleShow = () => {
        setIsEdit(false)
    }

    //編集したタスク名の保存
    const handleSave = () => {
        updateTask(props.task.id, taskRef.current)
        setIsEdit(false)
    }

    const refSave = (e) => {
        taskRef.current = e.target.value
    }

    const Edit = (props) => {
        return (
            <>
                <Input defaultValue={props.task.name} onChange={refSave} />
                <Button variant="solid" size="xs" ml={5} onClick={handleSave}>保存</Button>
                <Button variant="solid" size="xs" ml={5} onClick={handleShow}>キャンセル</Button>
            </>
        )
    }

    const Show = (props) => {
        return (
            <>
                <Box my='auto'><BiTask /></Box>
                <Box ml='5' my='auto'>{props.task.name}</Box>
            </>
        )
    }

    return (
        <>
            <ListItem border="1px solid #eee" mt={props.index>0 ? 5 : 0} px={8} py={3} display="block">
                <Flex>
                    <Flex w='60%'>
                        {isEdit ? <Edit task={props.task} /> : <Show task={props.task} /> }
                    </Flex>
                    <Spacer />
                    <Box my='auto' color='gray.400'>{moment(props.task.updated_at).format('YYYY-MM-DD')}</Box>

                    <Box ml='5' my='auto'>
                        <Button size='xs' onClick={handleIsEdit}>編集</Button>
                    </Box>

                    <Box my='auto'>
                        <Button size='xs' ml='5' colorScheme='pink'>削除</Button>
                    </Box>
                </Flex>
            </ListItem>
        </>
    )
}
