# Etl Challenge
This challenge consist on get a large amount of numbers from an API, roughly ~1000000 (one million) numbers, store it, sort after getting all the numbers and then presenting the results

## Installation:
  * Install dependencies and compile code `mix do deps.get, deps.compile`
  * Install Node.js dependencies with `npm install` inside the `assets` directory

## Startup
Start **Phoenix** as usual `mix phx.server`.

The process of fetch the API and handle the results will start with the **Phoenix** application and run asynchronously.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser or alternatively you can get the result in JSON format by accessing [`http://localhost:4000/api`](http://localhost:4000/api)

## Understanding the Results
When you access the []() page (or JSON API) you will get a temporary result while the application is working to get all the data.

If you see the status `process_status: processing` it means that the application is still fetching the numbers. You can follow along with the `list_size: n` information. The process of fetching data will end by the `list_size: 1000000` mark and this **step could take roughly 30 minutes to complete**.

After the application consumes all numbers from the source, it will start the `process_status: sorting` phase. This is much quicker than the previous step and should take less than a minute.

And then, finally, the result is ready to be presented. The status of the process will be `process_status: complete` and the results will show on the request.

> ⚠️ **You will need to refresh the page to see the progress of the process. This application does not include a LiveView feature yet**

## Testing
Just run `mix test` on your terminal, in the application root folder.

## Points of improvements
### Fetching data from API phase
The main bottleneck about this application is the API call phase so it would be nice to implement some sort of concurrent requests here, but the problem was to keep track of the pages already requested. After some time spent trying to think in a way to do this I changed course and implemented it in this way.

### More robust data storage
The only place that the data consumed by this app is stored is on the GenServer state. This works fine for this proof of concept, but could not remain as it is in a production environment. I did this way in order to use all the resource that Elixir provide since this app doesn't have any other dependencies
