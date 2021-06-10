

SELECT        D.Mission, D.PersonNo, D.PayrollItemName, D.PayrollItem, P.LastName, P.FirstName, P.Gender, P.Nationality, D.Currency, D.Entitlement, D.Settled, ROUND(D.Entitlement - D.Settled, 2) AS Balance
FROM            (SELECT        L.Mission, L.PersonNo, R.PayrollItemName, L.PayrollItem, L.Currency, ISNULL(ROUND(SUM(L.PaymentAmount), 2), 0) AS Entitlement,
                                                        (SELECT        ISNULL(ROUND(SUM(PaymentAmount), 2), 0) AS Expr1
                                                          FROM            EmployeeSettlementLine
                                                          WHERE        (Mission = L.Mission) AND (PersonNo = L.PersonNo) AND (PayrollItem = L.PayrollItem)) AS Settled
                          FROM            EmployeeSalaryLine AS L INNER JOIN
                                                    Ref_PayrollItem AS R ON L.PayrollItem = R.PayrollItem
                          WHERE        (R.SettlementMonth <> '0')
                          GROUP BY L.Mission, L.PersonNo, L.Currency, L.PayrollItem, R.PayrollItem, R.PayrollItemName) AS D INNER JOIN
                         Employee.dbo.Person AS P ON P.PersonNo = D.PersonNo
WHERE        (1 = 1)