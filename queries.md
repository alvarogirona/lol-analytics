```
SELECT 
	(cast(count(CASE WHEN is_win THEN 1 END) as float) / cast(count(*) as float)) * 100.0 as win_rate, 
	count(CASE WHEN is_win THEN 1 END) as games_won, 
	count(*) as total_games, 
	champion_id
	FROM fact_champion_played_game 
	GROUP BY champion_id
	ORDER BY win_rate desc;
```