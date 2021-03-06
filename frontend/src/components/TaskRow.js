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
import { destroyTask, validate } from '../models/task'

export const TaskRow = (props) => {
    const [isEdit, setIsEdit] = useState(false)
    const taskRef = useRef({})

    useEffect(() => {
        console.log("props:", props.task.name, props.index)
    })

    //編集エリアを表示
    const handleIsEdit = () => {
        setIsEdit(true)
    }

    //タスク情報の表示
    const handleShow = () => {
        setIsEdit(false)
    }

    //編集したタスク名の保存
    const handleSave = async () => {
        console.log("handleSave:", props.task.id)
        const result = await updateTask(props.task.id, taskRef.current.value)

        console.log("validate:", validate(result))
        if (validate(result)){
            props.getList()
        }
        
        setIsEdit(false) //APIレスポンスステータスがNGでも編集エリアは閉じる
    }

    const handleDestroy = async () => {
        if (window.confirm("削除してよいですか？")){
            const result = await destroyTask(props.task.id)
            if(validate(result)){
                props.getList()
            }
        }
    }

    const Edit = () => {
        return (
            <>
                <Input defaultValue={props.task.name} ref={taskRef} size="xs" focusBorderColor='pink.500' w='100%' />
                <Button variant="solid" size="xs" ml={5} px={3} onClick={handleSave} colorScheme='pink'>保存</Button>
                <Button variant="solid" size="xs" ml={5} px={5} onClick={handleShow}>キャンセル</Button>
            </>
        )
    }

    const Show = () => {
        return (
            <>
                <Box my='auto'><BiTask /></Box>
                <Box ml='5' my='auto'>{props.task.name}</Box>
            </>
        )
    }

    return (
        <>
            <ListItem border="1px solid #eee" mt={props.index>0 ? 5 : 0} px={3} py={3}>
                <Flex w='100%'>
                    <Flex w='70%'>
                        {isEdit ? <Edit /> : <Show /> }
                    </Flex>
                    
                    <Spacer />
                    <Flex align='right'>
                        <Box my='auto' color='gray.400' display={{base:"none", md:"block"}}>{moment(props.task.updated_at).format('YYYY-MM-DD')}</Box>
                        <Box ml='5' my='auto'>
                            <Button size='xs' colorScheme='pink' onClick={handleIsEdit}>編集</Button>
                        </Box>
                        <Box my='auto'>
                            <Button size='xs' ml='5' onClick={handleDestroy}>削除</Button>
                        </Box>
                    </Flex>
                </Flex>
            </ListItem>
        </>
    )
}
