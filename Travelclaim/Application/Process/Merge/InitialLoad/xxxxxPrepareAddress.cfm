
<cfquery name="step" 
datasource="appsTravelClaim" >
SELECT     C.PersonNo, A.AddressId, I.eff_date, I.strt_addr, 
I.addnl_strt_addr, I.city, I.postl_code, I.f_cnty_id_code, I.phone_1_num, 
I.extn1, I.phone_2_num, 
                      I.extn2, I.email_addr, 
I.contact_name, I.db_mdst_source, I.f_refx_adtr_seq_num, I.expir_date
INTO            tmp_ref3
FROM         stPerson C INNER 
JOIN
                      IMP_PERSONADDRESS I ON C.IndexNo 
= I.f_prsn_index_num LEFT OUTER 
JOIN
                      Employee.dbo.PersonAddress A ON 
I.f_refx_adtr_seq_num = A.AddressType AND C.PersonNo = A.PersonNo
</cfquery>


<cfquery name="step" 
datasource="appsTravelClaim" >
INSERT 
INTO Employee.dbo.PersonAddress
                      (PersonNo, 
AddressType, Address, Address2, AddressCity, AddressPostalCode, 
Country, Contact, TelephoneNo, EMailAddress, OfficerUserId, 

                      OfficerLastName, OfficerFirstName)
SELECT     PersonNo, f_refx_adtr_seq_num, strt_addr, addnl_strt_addr, 
city, postl_code, f_cnty_id_code, contact_name, phone_1_num, 
email_addr, 
                      'Nucleus' AS Expr1, 'Van 
Pelt' AS Expr2, 'Hanno' AS Expr3
FROM         tmp_ref3
WHERE  (AddressId IS NULL)
</cfquery>







 



