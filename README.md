# Project9
Paul Hudson #100DaysOfSwift



Why is locking the UI bad?

First, we used Data's contentsOf to download data from the internet, which is what's known as a blocking call. That is, it blocks execution of any further code in the method until it has connected to the server and fully downloaded all the data.

Second, behind the scenes your app actually executes multiple sets of instructions at the same time, which allows it to take advantage of having multiple CPU cores. Each CPU can be doing something independently of the others, which hugely boosts your performance. These code execution processes are called threads, and come with a number of important provisos:

Threads execute the code you give them, they don't just randomly execute a few lines from viewDidLoad() each. This means by default your own code executes on only one CPU, because you haven't created threads for other CPUs to work on.

All user interface work must occur on the main thread, which is the initial thread your program is created on. If you try to execute code on a different thread, it might work, it might fail to work, it might cause unexpected results, or it might just crash.

You don't get to control when threads execute, or in what order. You create them and give them to the system to run, and the system handles executing them as best it can.

Because you don't control the execution order, you need to be extra vigilant in your code to ensure only one thread modifies your data at one time.

The power of GCD is that it takes away a lot of the hassle of creating and working with multiple threads, known as multithreading. You don't have to worry about creating and destroying threads, and you don't have to worry about ensuring you have created the optimal number of threads for the current device. GCD automatically creates threads for you, and executes your code on them in the most efficient way it can.

To fix our project, you need to learn three new GCD functions, but the most important one is called async() – it means "run the following code asynchronously," i.e. don't block (stop what I'm doing right now) while it's executing. Yes, that seems simple, but there's a sting in the tail: you need to use closures. 

