-- Check if the favorite team Id is within the range of expected values
-- Therefore return records where this isn't true to make the test fail
select
    favourite_team_id
from {{ ref('user_data' )}}
where favourite_team_id > 10