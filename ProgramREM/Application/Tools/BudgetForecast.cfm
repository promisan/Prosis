<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="URL.Period" default="">
<cfparam name="URL.Mission" default="">

<cfquery name="Period" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Period
	WHERE   Period = '#URL.Period#'
</cfquery>

SELECT      SalarySchedule, MAX(PayrollEnd) AS Expr1
FROM        SalarySchedulePeriod
WHERE       Mission = '#url.mission#' 
AND         CalculationStatus = '3'
GROUP BY    SalarySchedule



<!--- define until which period we have already data posted under this effective period 

clean the prior postings
loop through each month per program and make a posting 

--->







