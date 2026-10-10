program StackQueue;

{ Stack (LIFO) и Queue (FIFO). }

var
  st: Stack<Integer>;
  q: Queue<String>;

begin
  WriteLn('--- Stack ---');
  st := new Stack<Integer>;
  st.Push(1);
  st.Push(2);
  st.Push(3);

  while st.Count > 0 do
    WriteLn('Pop: ', st.Pop);

  WriteLn('--- Queue ---');
  q := new Queue<String>;
  q.Enqueue('Иван');
  q.Enqueue('Мария');
  q.Enqueue('Пётр');

  while q.Count > 0 do
    WriteLn('Dequeue: ', q.Dequeue);
end.