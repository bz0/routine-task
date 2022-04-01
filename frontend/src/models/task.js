const url = 'http://' + process.env.REACT_APP_BACKEND_DOMAIN + '/tasks';
const bearerToken = "Bearer " + process.env.REACT_APP_API_TOKEN

export const getTaskList = async () => {
  // countに応じてアクセスするAPIを変えなければならない
  const response = await fetch(url,{
    headers: {
      Authorization: bearerToken
    }
  })
  const body = await response.json()
  return body
};

export const createTask = async (name) => {
    await fetch(url,{
        method: 'POST',
        body : JSON.stringify({name: name}),
        headers: {
          'Content-Type': 'application/json',
          Authorization: bearerToken
        }
    });
}

export const updateTask = async (id, name) => {
  console.log("id+name:", id, name)
  await fetch(url,{
      method: 'PATCH',
      body : JSON.stringify({id: id, name: name}),
      headers: {
        'Content-Type': 'application/json',
        Authorization: bearerToken
      }
  });
}