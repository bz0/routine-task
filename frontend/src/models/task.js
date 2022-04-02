const url = 'http://' + process.env.REACT_APP_BACKEND_DOMAIN + '/tasks';
const bearerToken = "Bearer " + process.env.REACT_APP_API_TOKEN

//APIレスポンスステータスが「NG」のとき
//アラートでエラーメッセージを表示する
export const validate = (result) => {
  if(result.status==="NG"){
    alert(result.error.message)
    return false
  }
  return true
} 

export const getTaskList = async () => {
  return await(await fetch(url,{
    headers: {
      Authorization: bearerToken
    }
  })).json()
};

export const createTask = async (name) => {
  return await(await fetch(url,{
      method: 'POST',
      body : JSON.stringify({name: name}),
      headers: {
        'Content-Type': 'application/json',
        Authorization: bearerToken
      }
  })).json()
}

export const updateTask = async (id, name) => {
  const patchUrl = url + '/' + id
  return await(await fetch(patchUrl,{
      method: 'PATCH',
      body : JSON.stringify({id: id, name: name}),
      headers: {
        'Content-Type': 'application/json',
        Authorization: bearerToken
      }
  })).json()
}

export const destroyTask = async (id) => {
  const deleteUrl = url + '/' + id
  return await(await fetch(deleteUrl,{
      method: 'DELETE',
      headers: {
        Authorization: bearerToken
      }
  })).json()
}