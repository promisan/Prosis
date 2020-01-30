
<!--- PositionListing.cfm?ID1=#Level02.OrgUnitCode#&ID2=#Mission#&ID3=#URL.MandateNo#&Source=#URL.Source#&ApplicantNo=#URL.ApplicantNo#&PersonNo=#URL.PersonNo#&RecordId=#URL.RecordId#&DocumentNo=#URL.DocumentNo#' --->

<cfoutput query="level01">
	  
	   ['#Level01.OrgUnitName#','PositionPassTru.cfm?class=#class#&ID1=#Level01.OrgUnit#&ID2=#Mission#&ID3=#URL.MandateNo#&Source=#URL.Source#&ApplicantNo=#URL.ApplicantNo#&PersonNo=#URL.PersonNo#&RecordId=#URL.RecordId#&DocumentNo=#URL.DocumentNo#',		
	   
	   <cfquery name="Level02" dbtype="query" >
	    	  SELECT  * 
		      FROM   BaseSet
		 	  WHERE ParentOrgUnit = '#Level01.OrgUnitCode#'
			  ORDER BY TreeOrder, OrgUnitName
		</cfquery>
		 
      <cfloop query="level02">
	  
	  	  	['#Level02.OrgUnitName#','PositionPassTru.cfm?class=#class#&ID1=#Level02.OrgUnit#&ID2=#Mission#&ID3=#URL.MandateNo#&Source=#URL.Source#&ApplicantNo=#URL.ApplicantNo#&PersonNo=#URL.PersonNo#&RecordId=#URL.RecordId#&DocumentNo=#URL.DocumentNo#',	
				
			<cfquery name="Level03" dbtype="query" >
		    	  SELECT  * 
			      FROM   BaseSet
			 	  WHERE ParentOrgUnit = '#Level02.OrgUnitCode#'
				  ORDER BY TreeOrder, OrgUnitName
			</cfquery>
				        
             <cfloop query="level03">
			 
			 		['#Level03.OrgUnitName#','PositionPassTru.cfm?class=#class#&ID1=#Level03.OrgUnit#&ID2=#Mission#&ID3=#URL.MandateNo#&Source=#URL.Source#&ApplicantNo=#URL.ApplicantNo#&PersonNo=#URL.PersonNo#&RecordId=#URL.RecordId#&DocumentNo=#URL.DocumentNo#',			
					
					<cfquery name="Level04" dbtype="query" >
			    	  SELECT  * 
				      FROM   BaseSet
				 	  WHERE ParentOrgUnit = '#Level03.OrgUnitCode#'
					  ORDER BY TreeOrder, OrgUnitName
					</cfquery>	
				    	  
                <cfloop query="level04">
				
				 	['#Level04.OrgUnitName#','PositionPassTru.cfm?class=#class#&ID1=#Level04.OrgUnit#&ID2=#Mission#&ID3=#URL.MandateNo#&Source=#URL.Source#&ApplicantNo=#URL.ApplicantNo#&PersonNo=#URL.PersonNo#&RecordId=#URL.RecordId#&DocumentNo=#URL.DocumentNo#',					
					
						<cfquery name="Level05" dbtype="query" >
				    	  SELECT  * 
					      FROM   BaseSet
					 	  WHERE ParentOrgUnit = '#Level04.OrgUnitCode#'
						  ORDER BY TreeOrder, OrgUnitName
						</cfquery>	
					    	   
	                  <cfloop query="level05">
				 		['#Level05.OrgUnitName#','PositionPassTru.cfm?class=#class#&ID1=#Level05.OrgUnit#&ID2=#Mission#&ID3=#URL.MandateNo#&Source=#URL.Source#&ApplicantNo=#URL.ApplicantNo#&PersonNo=#URL.PersonNo#&RecordId=#URL.RecordId#&DocumentNo=#URL.DocumentNo#',						
						
							<cfquery name="Level06" dbtype="query">
					    	  SELECT  * 
						      FROM   BaseSet
						 	  WHERE ParentOrgUnit = '#Level05.OrgUnitCode#'
							  ORDER BY TreeOrder, OrgUnitName
							</cfquery>	
											
				  	    	<cfloop query="level06">
						  		['#Level06.OrgUnitName#','PositionPassTru.cfm?class=#class#&ID1=#Level06.OrgUnit#&ID2=#Mission#&ID3=#URL.MandateNo#&Source=#URL.Source#&ApplicantNo=#URL.ApplicantNo#&PersonNo=#URL.PersonNo#&RecordId=#URL.RecordId#&DocumentNo=#URL.DocumentNo#'],
	         	    	    </cfloop>],
	  
         	      </cfloop>],
	  
       	        </cfloop>],
	  
       	     </cfloop>],
			 			   	  
	     </cfloop>],
		 
 </cfoutput>