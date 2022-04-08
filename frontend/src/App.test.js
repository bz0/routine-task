import React from 'react';
import { render } from './test-utils';
import Home from './pages/Home';

const tasksResult = {
  message: "ok",
  count: 3,
  data:[
    {
      name: "散歩する",
      created_at: "2022-04-08 00:00:00",
      updated_at: "2022-04-08 00:00:00",
      deleted_at: null
    },
    {
      name: "掃除する",
      created_at: "2022-04-08 00:00:00",
      updated_at: "2022-04-08 00:00:00",
      deleted_at: null
    },
    {
      name: "体操する",
      created_at: "2022-04-08 00:00:00",
      updated_at: "2022-04-08 00:00:00",
      deleted_at: null
    }
  ]
}

test("3件表示", async () => {
  const tasksMock = () =>
    new Promise((resolve) => {
      resolve({
        ok: true,
        status: 200,
        json: async () => (tasksResult)
      })
    })
  
  global.fetch = jest.fn().mockImplementation(tasksMock)
  const tasks = render(<Home />)

  //出力されるカード数と件数をチェック
  expect(await tasks.getByTestId('count').textContent).toBe("3")
  expect(await tasks.getByTestId('tasks').childElementCount).toBe(3)
})