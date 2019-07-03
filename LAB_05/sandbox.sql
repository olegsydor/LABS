/* n! */
;WITH F_CTE (rowOrder, nFaktorial) AS
(SELECT 1 AS rowOrder, 1 AS nFaktorial
UNION ALL
SELECT rowOrder+1 AS rowOrder, nFaktorial*(rowOrder+1) AS nFaktorial
from F_CTE AS S_CTE
where S_CTE.rowOrder < 10
)
SELECT TOP 1 rowOrder, nFaktorial FROM F_CTE
ORDER BY rowOrder DESC
GO

/* Fibonacci */
;WITH F_CTE (rowOrder, nFibo, n0Fibo) AS
(SELECT 1 as rowOrder, 1 as nFibo, 0 as n0Fibo
UNION ALL
SELECT rowOrder+1, nFibo+n0Fibo, nFibo
from F_CTE AS S_CTE
where S_CTE.rowOrder < 20
)
SELECT rowOrder, nFibo FROM F_CTE
ORDER BY rowOrder DESC
GO