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



GCD 101: async()


We're going to use async() twice: once to push some code to a background thread, then once more to push code back to the main thread. This allows us to do any heavy lifting away from the user interface where we don't block things, but then update the user interface safely on the main thread – which is the only place it can be safely updated.

GCD creates for you a number of queues, and places tasks in those queues depending on how important you say they are. All are FIFO, meaning that each block of code will be taken off the queue in the order they were put in, but more than one code block can be executed at the same time so the finish order isn't guaranteed.

“How important” some code is depends on something called “quality of service”, or QoS, which decides what level of service this code should be given. Obviously at the top of this is the main queue, which runs on your main thread, and should be used to schedule any work that must update the user interface immediately even when that means blocking your program from doing anything else. But there are four background queues that you can use, each of which has their own QoS level set:

User Interactive: this is the highest priority background thread, and should be used when you want a background thread to do work that is important to keep your user interface working. This priority will ask the system to dedicate nearly all available CPU time to you to get the job done as quickly as possible.

User Initiated: this should be used to execute tasks requested by the user that they are now waiting for in order to continue using your app. It's not as important as user interactive work – i.e., if the user taps on buttons to do other stuff, that should be executed first – but it is important because you're keeping the user waiting.

The Utility queue: this should be used for long-running tasks that the user is aware of, but not necessarily desperate for now. If the user has requested something and can happily leave it running while they do something else with your app, you should use Utility.

The Background queue: this is for long-running tasks that the user isn't actively aware of, or at least doesn't care about its progress or when it completes.


If you want to try the other QoS queues, you could also use .userInteractive, .utility or .background.
