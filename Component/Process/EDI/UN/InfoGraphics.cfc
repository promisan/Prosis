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
<cffunction name="gender"
        access="public"
        returntype="query"
        displayname="Gender stat">
		
		<cfargument name="Entity" type="string" default="- DD" required="yes">
		<cfargument name="SelectionDates" type="string" default="''" required="yes">
						
		<cfquery name="Period" 
			datasource="martStaffing" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT        DataMart, SelectionDate, Status, Filter, Preparation, Memo, Created
            FROM            Period
            WHERE        (DataMart = 'Gender') AND (Status != '0')
			AND  		 SelectionDate IN (#preserveSingleQuotes(SelectionDates)#)
		</cfquery>		
		
		<cfquery name="Result" 
			datasource="martStaffing" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">				
			
			SELECT      GradeContract, GradeContractOrder, Gender,  
			
						<cfloop query="Period">
										
						   (SELECT       COUNT(*) AS ThisMonth 
							FROM         Gender
							WHERE        Mission          = '#entity#' 
							AND          TransactionType  = '0' 
							AND          SelectionDate    = '#selectiondate#' 
							AND          PositionSeconded = '0' 
							AND          AssignmentType <> 'LI' 
							AND          AppointmentTypeName <> 'Temporary' 
							AND          GradeContractOrder < 20 
							AND          GradeContract    = G.GradeContract 
							AND          Gender           = G.Gender
							) as #dateformat(selectiondate,'MMMYY')# ,		
							
						   (SELECT       COUNT(*) AS ThisMonth 
							FROM         Gender
							WHERE        Mission          = '#entity#' 
							AND          TransactionType  = '0' 
							AND          SelectionDate    = '#selectiondate#' 
							AND          PositionSeconded = '0' 
							AND          AssignmentType <> 'LI' 
							AND          AppointmentTypeName <> 'Temporary' 
							AND          GradeContractOrder < 20 
							AND          GradeContract    = G.GradeContract 							
							) as #dateformat(selectiondate,'MMMYY')#_Total ,		
							
							ROUND (
							
							   CAST (
						
								(SELECT       COUNT(*) AS ThisMonth 
								FROM         Gender
								WHERE        Mission          = '#entity#' 
								AND          TransactionType  = '0' 
								AND          SelectionDate    = '#selectiondate#' 
								AND          PositionSeconded = '0' 
								AND          AssignmentType <> 'LI' 
								AND          AppointmentTypeName <> 'Temporary' 
								AND          GradeContractOrder < 20 
								AND          GradeContract    = G.GradeContract 
								AND          Gender           = G.Gender
								) * 100	 AS FLOAT)							
								
								/ 

								CASE
								WHEN 
									ISNULL((
										SELECT     COUNT(*) AS ThisMonth 
										FROM         Gender
										WHERE        Mission          = '#entity#' 
										AND          TransactionType  = '0' 
										AND          SelectionDate    = '#selectiondate#' 
										AND          PositionSeconded = '0' 
										AND          AssignmentType <> 'LI' 
										AND          AppointmentTypeName <> 'Temporary' 
										AND          GradeContractOrder < 20 
										AND          GradeContract    = G.GradeContract 							
									), 0) = 0 
								THEN 1
								ELSE
									ISNULL((
										SELECT     COUNT(*) AS ThisMonth 
										FROM         Gender
										WHERE        Mission          = '#entity#' 
										AND          TransactionType  = '0' 
										AND          SelectionDate    = '#selectiondate#' 
										AND          PositionSeconded = '0' 
										AND          AssignmentType <> 'LI' 
										AND          AppointmentTypeName <> 'Temporary' 
										AND          GradeContractOrder < 20 
										AND          GradeContract    = G.GradeContract 							
									), 0)
								END
							
							,0) as #dateformat(selectiondate,'MMMYY')#_Percent ,													
						
						</cfloop>		
						
						COUNT(*) AS DPPADPOTotal122021
						
			FROM        Gender G
			WHERE       Mission             = 'DD'
			AND         SelectionDate       = '12/31/2021' 
			AND         PositionSeconded    = '0' 
			AND         AssignmentType      <> 'LI' 
			AND         AppointmentTypeName <> 'Temporary' 
			AND         GradeContractOrder > 3
			AND         GradeContractOrder  < 20 
			AND         TransactionType     = '0' 
			GROUP BY    GradeContract, GradeContractOrder, Gender
			ORDER BY    GradeContractOrder, Gender DESC
			
		</cfquery>		
				
		<cfreturn result>
				
</cffunction>	

<cffunction name="geographic"
        access="public"
        returntype="query"
        displayname="geographic">
		
		<cfargument name="Entity"        type="string" 	default="- DD"   required="yes">
		<cfargument name="SelectionDates" type="string" default="''" required="yes">

		<cfquery name="Period" 
			datasource="martStaffing" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT        DataMart, SelectionDate, Status, Filter, Preparation, Memo, Created
            FROM            Period
            WHERE        (DataMart = 'Gender') AND (Status != '0')
			AND  		 SelectionDate IN (#preserveSingleQuotes(SelectionDates)#)
		</cfquery>	
		
		<cfquery name="Result" 
			datasource="martStaffing" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				
			    SELECT D.Status 			
				
				<cfloop query="Period">			
					, sum(#dateformat(selectiondate,'MMMYY')#) as #dateformat(selectiondate,'MMMYY')# 
					
					,	(SELECT    COUNT(*)
						 FROM      Gender
						 WHERE     Mission             = '#entity#' 
						 AND       TransactionType     = '0' 
						 AND       SelectionDate       = '#selectiondate#' 
						 AND       PositionSeconded    = '0' 
						 AND       AssignmentType      <> 'LI' 
						 AND       AppointmentTypeName <> 'Temporary' 
						 AND       PositionNature      = 'Geographical' 
						 AND       GradeContractOrder  > 3
				         AND       GradeContractOrder  < 20  ) as #dateformat(selectiondate,'MMMYY')#_Total 
					
					
					 ,	ROUND( 
					 			 
					     CAST (sum(#dateformat(selectiondate,'MMMYY')#) * 100 AS FLOAT) / 

						  CASE
								WHEN 
									ISNULL((
										SELECT    COUNT(*)  
										FROM      Gender
										WHERE     Mission             = '#entity#' 
										AND       TransactionType     = '0' 
										AND       SelectionDate       = '#selectiondate#' 
										AND       PositionSeconded    = '0' 
										AND       AssignmentType      <> 'LI' 
										AND       AppointmentTypeName <> 'Temporary' 
										AND       PositionNature      = 'Geographical' 
										AND       GradeContractOrder  > 3
										AND       GradeContractOrder  < 20  							
									), 0) = 0 
								THEN 1
								ELSE
									ISNULL((
										SELECT    COUNT(*)  
										FROM      Gender
										WHERE     Mission             = '#entity#' 
										AND       TransactionType     = '0' 
										AND       SelectionDate       = '#selectiondate#' 
										AND       PositionSeconded    = '0' 
										AND       AssignmentType      <> 'LI' 
										AND       AppointmentTypeName <> 'Temporary' 
										AND       PositionNature      = 'Geographical' 
										AND       GradeContractOrder  > 3
										AND       GradeContractOrder  < 20   							
									), 0)
								END
						  						 
						 ,1) as #dateformat(selectiondate,'MMMYY')#_Percent	
						
												
				</cfloop>						       
				
				FROM ( 
				
					SELECT        G.Code,  R.Status
					
					<cfloop query="Period">				
					,
					(SELECT    COUNT(*) AS ThisMonth 
					 FROM      Gender
					 WHERE     Mission             = '#entity#' 
					 AND       TransactionType     = '0' 
					 AND       SelectionDate       = '#selectiondate#' 
					 AND       PositionSeconded    = '0' 
					 AND       AssignmentType      <> 'LI' 
					 AND       AppointmentTypeName <> 'Temporary' 
					 AND       PositionNature      = 'Geographical' 
					 AND       GradeContractOrder  > 3
			         AND       GradeContractOrder  < 20  
					 AND       NationalityCode     = G.ISOCODE2 ) as #dateformat(selectiondate,'MMMYY')#							
					</cfloop>																
				
					FROM  Nova.dbo.Ref_Nation G INNER JOIN Nova.dbo.Ref_NationIndicator R 
					        ON StatusClass = 'Represent' 
							AND DateEffective = '2021-07-31'    <!--- last available information --->
							AND G.Code = R.Code						
					GROUP BY G.Code, R.Status, G.ISOCode2
				
			    ) as D 
				
				WHERE Status != '5. Unrepresented'
				
			    GROUP BY D.Status
				
		</cfquery>	
		
		<cfreturn result>	
		
</cffunction>		


<cffunction name="regional"
        access="public"
        returntype="query"
        displayname="geographic">
		
		<cfargument name="Entity"        type="string" 	default="- DD"   required="yes">
		<cfargument name="SelectionDates" type="string" default="''" required="yes">
						
		<cfquery name="Period" 
			datasource="martStaffing" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT        DataMart, SelectionDate, Status, Filter, Preparation, Memo, Created
            FROM            Period
            WHERE        (DataMart = 'Gender') AND (Status != '0')
			AND  		 SelectionDate IN (#preserveSingleQuotes(SelectionDates)#)
		</cfquery>
		
		<cfquery name="Result" 
			datasource="martStaffing" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">				
			
			SELECT        LocationCountry, 
			
			<cfloop query="Period">
							
			   (SELECT    COUNT(*) AS ThisMonth 
				FROM      Gender
				WHERE     Mission = '#entity#' 
				AND       TransactionType = '0' 
				AND       SelectionDate = '#selectiondate#' 				
				AND       AssignmentType <> 'LI' 
				AND       AppointmentTypeName <> 'xTemporary' 
				AND       GradeContractOrder > 3
			    AND       GradeContractOrder  < 20  
				AND       LocationCountry = G.LocationCountry
				) as #dateformat(selectiondate,'MMMYY')# ,		
				
			   (SELECT    COUNT(*) AS ThisMonth 
				FROM      Gender
				WHERE     Mission = '#entity#' 
				AND       TransactionType = '0' 
				AND       SelectionDate = '#selectiondate#' 				
				AND       AssignmentType <> 'LI' 
				AND       AppointmentTypeName <> 'xTemporary' 
				AND       GradeContractOrder > 3
			    AND       GradeContractOrder  < 20
				) as #dateformat(selectiondate,'MMMYY')#_Total ,		
				
				ROUND(
				
					CAST (
				
					 (SELECT    COUNT(*) AS ThisMonth 
					  FROM      Gender
					  WHERE     Mission = '#entity#' 
					  AND       TransactionType = '0' 
					  AND       SelectionDate = '#selectiondate#' 				
					  AND       AssignmentType <> 'LI' 
					  AND       AppointmentTypeName <> 'xTemporary' 
					  AND       GradeContractOrder > 3
				      AND       GradeContractOrder  < 20  
					  AND       LocationCountry = G.LocationCountry ) * 100 
					  
					  AS FLOAT)
					  
					  /		

					CASE
								WHEN 
									ISNULL((
										SELECT    COUNT(*) AS ThisMonth 
										FROM      Gender
										WHERE     Mission = '#entity#' 
										AND       TransactionType = '0' 
										AND       SelectionDate = '#selectiondate#' 				
										AND       AssignmentType <> 'LI' 
										AND       AppointmentTypeName <> 'xTemporary' 
										AND       GradeContractOrder > 3
										AND       GradeContractOrder  < 20  							
									), 0) = 0 
								THEN 1
								ELSE
									ISNULL((
										SELECT    COUNT(*) AS ThisMonth 
										FROM      Gender
										WHERE     Mission = '#entity#' 
										AND       TransactionType = '0' 
										AND       SelectionDate = '#selectiondate#' 				
										AND       AssignmentType <> 'LI' 
										AND       AppointmentTypeName <> 'xTemporary' 
										AND       GradeContractOrder > 3
										AND       GradeContractOrder  < 20  							
									), 0)
								END
					 
					 ,1) as #dateformat(selectiondate,'MMMYY')#_Percent ,	
					
			</cfloop>		
		
			COUNT(*) AS DPPADPOTotal122021
			
			FROM        Gender G
			WHERE       Mission = 'DD'
			AND         SelectionDate = '12/31/2021' 
			AND         AssignmentType <> 'LI' 
			AND         AppointmentTypeName <> 'xTemporary' 
			AND         GradeContractOrder < 20 
			AND         TransactionType = '0' 
			GROUP BY    LocationCountry
			ORDER BY    LocationCountry 
			
		</cfquery>	
		
		<cfreturn result>									
		
		
</cffunction>		