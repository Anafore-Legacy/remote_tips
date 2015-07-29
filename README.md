Remote Testing Tips
===

5 Ruby tips for the Singapore Ruby meetup!

Check out the spec folder to see an example for each section.

Outlined below are a series of tips building on each other to describe how to avoid going over the wire in your Ruby tests.

The example specs can all be run with:

    git clone https://github.com/Anafore/remote_tips.git
    cd remote_tips
    bundle
    bundle exec rspec
    
VCR cassettes are already included.

Tips
=====

**Stub All The Things**

The simplest approach, better for when you don't really care about the API.

Consider this if the particular tests you're writing are testing around remote behavior rather than about remote behavior.

Good for testing code around an already well-tested client.

Major drawback is you get much less integration assurance, but hey it's quick.

**Mock HTTP**

In this example, we switch to writing the code that makes the HTTP requests through `RestClient`.

We use `WebMock` to return some hardcoded responses to specific HTTP requests.

This is great because it means we have everything between the code we're testing and `Net::HTTP` covered, but limited because if the server changes, or our needs from the server, there's a high degree of maintenance to get the test up to speed.

This approach is mainly appropriate when you have few, very specific HTTP calls which you intend to depend on.

Also if you don't get the responses right your tests aren't going to mimic reality.

**Record/Replay**

If you want to be certain your tests are mimicing reality, you might want to record and replay real HTTP responses. In our example, we use the excellent `VCR`.

This is great because long, complex series of requests can be recorded once and then replayed without ever having to go over the wire again.

However, the problem with reality is that it's sometimes difficult to make a server behave just how you want to optimally test out your code. Sometimes you need to do setup/teardown over the wire, and in the worst case, some of this might have to be manual.

This means that re-recording tests when something changes can be very confusing and time consuming. It's still a huge improvement over manually written stubs, though.

**Fake Server**

If the server behavior you care about is relatively simple you can build your own mock server rather than just hardcoded responses. In our example, we use `ShamRack` however `WebMock` also has similar capabilities.

This can be difficult to justify as it means you have to actually write server code that you're only using in tests, but this fake server can be used across all of your tests and even in development.

If you want tests that induce changes in server state that's easy to mimic and is used widely throughout your code, you may want to consider the investment.

**Shared Server**

Why use a fake server when you could use the real server? If you're building a client for an server you run as well then it may be possible to modularize the server code and plug it directly into your tests. We use `ShamRack` again for this.

There are huge benefits to be realized here if you're building an SOA architecture because it almost entirely does away with the pain of testing code that depends on the API of a different server.

It's not always easy or wise to extract the server in such a way, but the degree of testability a client gem offers that includes the server within it for testing purposes simply can't be beaten.


Join us!
=====

[ReferralCandy](http://www.referralcandy.com/jobs)
