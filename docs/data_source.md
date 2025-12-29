# Our data source: gharchive

The data comes from https://www.gharchive.org/, which contains a full backup
of all public Github events, commits, issues, PRs, etc.

The data can be downloaded in compressed jsons containing all events of one
hour of Github activity. For example, https://data.gharchive.org/2024-11-27-14.json.gz
contains all events from 2024-11-27 from 14:00-15:00. Each hour is about ~170 MB.

For documentation regarding the various event types and contents of the
corresponding jsons, see
https://docs.github.com/en/rest/using-the-rest-api/github-event-types?apiVersion=2022-11-28
