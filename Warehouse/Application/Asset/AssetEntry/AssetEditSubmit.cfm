
<cfajaximport>


<cfset dateValue = "">
<CF_DateConvert Value="#Form.InspectionDate#">
<cfset DTE = dateValue>

<cfparam name="form.itemNo" default="">

<cfset dateValue = "">
<CF_DateConvert Value="#Form.ReceiptDate#">
<cfset RCT = dateValue>

<cfset base = replace(Form.DepreciationBase,",","")>

<cfquery name="Asset" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM AssetItem		
		WHERE AssetId = '#URL.AssetId#'		
</cfquery>

<cfset Form.ItemNo = Asset.ItemNo>


<cf_tl id="Asset journal has not been recorded." var="1">
<cfset msg1="#lt_text#">

<cf_tl id="Operation not allowed." var="1">
<cfset msg2="#lt_text#">

<cf_tl id="Accounting information has not been defined for" var="1" class="Message">
<cfset msg3="#lt_text#">			

<cf_tl id="Item does not have a standard cost defined." var="1">
<cfset msg4="#lt_text#">


<cfparam name="Form.Description" default="">

<cfif asset.recordcount eq "1">

	<cftransaction>
	
		<!--- check if any changes are made --->
		
		<!--- 31/7/20122 pending to track if changes were made in the logging --->
		
		<cfif Asset.Description neq Form.Description or
			 dateformat(Asset.InspectionDate,CLIENT.DateFormatShow) neq Form.InspectionDate or
			 dateformat(Asset.ReceiptDate,CLIENT.DateFormatShow) neq Form.ReceiptDate or
			 Asset.SerialNo neq Form.SerialNo or
			 Asset.Make neq Form.Make or
			 Asset.MakeNo neq Form.MakeNo or
			 Asset.AssetDecalNo neq Form.AssetDecalNo or
			 Asset.Model neq Form.Model or
			 Asset.ProgramCode neq Form.ProgramCode or
			 Asset.InspectionNo neq Form.InspectionNo or
			 Asset.Source neq Form.Source or
			 Asset.AssetBarCode neq Form.BarCode or
			 Asset.ItemWeight neq Form.ItemWeight or
			 Asset.ItemVolume neq Form.ItemVolume or
			 Asset.ItemMemo neq Form.ItemMemo or
			 Asset.Operational neq Form.Operational or
			 Asset.DepreciationBase neq base or
			 Asset.DepreciationYearStart neq Form.DepreciationYearStart>
			 
			 <!--- log the old content first --->		
			
			<cfquery name="InsertLog" 
			 datasource="appsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 INSERT INTO AssetItemLog
					 (AssetId,
					 LogStamp, 
					 Mission, 
					 ProgramCode, 
					 ItemNo, 
					 SerialNo, 
					 Make,MakeNo, 
					 Model, 	
					 Source,				
					 Description, 
					 AssetBarCode, 
					 AssetDecalNo,
					 ReceiptDate, 
					 InspectionNo,InspectionDate, 
					 ItemWeight,ItemVolume, 
					 ItemMemo, 
					 DepreciationBase,DepreciationYearStart, 
					 Operational,
					 OfficerUserId, OfficerLastName, OfficerFirstName)				  
				SELECT   '#URL.AssetId#',
				         getDate(), 
						 Mission, 
						 ProgramCode, 
						 ItemNo, 
						 SerialNo, 
						 Make, MakeNo, 
						 Model, 	
						 Source,					
						 Description, 
						 AssetBarCode, 
						 AssetDecalNo,
						 ReceiptDate, 
						 InspectionNo, InspectionDate, 
						 ItemWeight, ItemVolume, 
						 ItemMemo, 
						 DepreciationBase, 
						 DepreciationYearStart, 
						 Operational, 
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName
				FROM   AssetItem
				WHERE  AssetId = '#URL.AssetId#'			
			</cfquery>		
			
			<!--- now we update --->	
						 
			<cfquery name="Edit" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE AssetItem
					SET Description           = '#Form.Description#',
					    <cfif Form.InspectionDate neq "">
						InspectionDate        = #DTE#,
						</cfif>
						<cfif Form.ItemNo neq "" and Form.ItemUoM neq "">
						ItemNo                = '#Form.ItemNo#',
						</cfif>
						ReceiptDate           = #RCT#,
						SerialNo              = '#Form.SerialNo#', 
						Make                  = '#Form.Make#', 
						MakeNo                = '#Form.MakeNo#', 
						ProgramCode           = '#Form.ProgramCode#',
						Source                = '#Form.Source#', 
						AssetBarCode          = '#Form.BarCode#',
						AssetDecalNo          = '#Form.AssetDecalNo#',
						Model                 = '#Form.Model#', 				
						InspectionNo          = '#Form.InspectionNo#', 
						ItemWeight            = '#Form.ItemWeight#', 
						ItemVolume            = '#Form.ItemVolume#', 
						ItemMemo              = '#Form.ItemMemo#',
						Operational			  = '#Form.Operational#',
						DepreciationBase      = '#Replace(base,",","","all")#', 
			            DepreciationYearStart = '#Form.DepreciationYearStart#',
						OfficerUserId         = '#session.acc#',
						OfficerLastName       = '#session.last#',
						OfficerFirstName      = '#session.first#'
						<!---
						, Created               = getDate()
						--->
				WHERE   AssetId = '#URL.AssetId#'		
			</cfquery>
			
			
			
			
		
		</cfif>
		
		<!--- AssetAction --->
			
			<cfquery name="ClearActionList" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  DELETE FROM AssetItemAssetAction
				  WHERE AssetId = '#URL.AssetId#'
			</cfquery>
			
			<cfquery name="ActionList" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT	*
				  FROM  	Ref_AssetAction A
				  WHERE		A.Operational = 1
			</cfquery>
			
			<cfloop query="ActionList">
			
				<cfif isDefined("Form.action_#code#")>
					
					<cfset vOperational = 0>				
					<cfif isDefined("Form.action_#code#_operational")>
						<cfset vOperational = 1>
					</cfif>
					
					
					<cfquery name="InsertLog" 
					 datasource="appsMaterials" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 	INSERT INTO AssetItemAssetAction
							(
								AssetId,
								ActionCategory,
								Operational,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName 
							)
						VALUES
							(
								'#URL.AssetId#',
								'#code#',
								#vOperational#,
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#'
							)
					 </cfquery>
				</cfif>
			</cfloop>
				
		<cfif Form.ItemNo neq "" and Form.ItemUoM neq "">
		
			<cfquery name="Update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE ItemTransaction
			SET    ItemNo         = '#Form.ItemNo#',
			       TransactionUoM = '#Form.ItemUoM#'			   
			WHERE  TransactionId IN (SELECT TransactionId FROM AssetItem WHERE AssetId = '#URL.AssetId#')
			</cfquery>
				
		</cfif>
		
		 <!--- ---------------------------------- --->
		 <!--- ---------- custom fields --------- --->
		 <!--- ---------------------------------- --->
		 
		<cfset ass = Asset.itemNo>
		
		<cfquery name="GetTopics" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT *
			  FROM   Ref_Topic
			  WHERE  Code IN (SELECT Code 
						      FROM   ItemTopic 
							  WHERE  ItemNo = '#ass#') 
			  AND    Operational = 1		
		</cfquery>
		  
		<cfquery name="Clean" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM AssetItemTopic
				WHERE AssetId = '#URL.AssetId#'
		</cfquery>
		
										
		<cfloop query="getTopics">
		
			
			    <cfif ValueClass eq "List">
				
					<cfparam name="Form.Topic_#Ass#_#Code#" default="">			
	  		        <cfset value  = Evaluate("Form.Topic_#Ass#_#Code#")>
																	
					 <cfquery name="GetList" 
							  datasource="AppsMaterials" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
							  SELECT *
							  FROM Ref_TopicList T
							  WHERE T.Code = '#Code#'
							  AND   T.ListCode = '#value#'				  
					</cfquery>
								
					<cfif value neq "">
								
					<cfquery name="InsertTopics" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  INSERT INTO AssetItemTopic
					 		 (AssetId,Topic,ListCode,TopicValue)
					  VALUES ('#URL.AssetId#','#Code#','#value#','#getList.ListValue#')
					</cfquery>
					
					</cfif>
					
				<cfelse>
				
					<cfif ValueClass eq "Boolean">
					
						<cfparam name="Form.Topic_#Ass#_#Code#" default="0">
						
					</cfif>
					
					<cfparam name="Form.Topic_#Ass#_#Code#" default="">			
									
	  		        <cfset value  = Evaluate("Form.Topic_#Ass#_#Code#")>
					
					<cfif value neq "">
					
						<cfquery name="InsertTopics" 
						  datasource="AppsMaterials" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						  INSERT INTO AssetItemTopic
						 		 (AssetId, Topic, TopicValue)
						  VALUES ('#URL.AssetId#','#Code#','#value#')
						</cfquery>	
					
					</cfif>
				
				</cfif>	
						
			</cfloop>		 
	  


           <cfset st = "1">
           
           <cf_verifyOperational 
                     datasource="appsMaterials"
              		 module="Accounting" 
                     Warning="No">

	       <cfquery name="qCheckHeader" 
	          datasource="appsMaterials" 
	          username="#SESSION.login#" 
	          password="#SESSION.dbpw#">
				SELECT   *
				FROM   Accounting.dbo.TransactionHeader
				WHERE  ReferenceId = '#URL.AssetId#'
	       </cfquery>		           
                                                                                
           <cfif ModuleEnabled eq "1" and qCheckHeader.recordCount eq 0>


				   <cfset base = replace(Form.DepreciationBase,",","")>
				   <cfset price = Replace(base,",","","all")>
					
                   <cfquery name="qAsset" 
                      datasource="appsMaterials" 
                      username="#SESSION.login#" 
                      password="#SESSION.dbpw#">
						SELECT   *
						FROM   AssetItem
						WHERE  AssetId = '#URL.AssetId#'
                   </cfquery>		           
           
           		   <cfset mis = qAsset.Mission>
           		   
					<cfquery name="Mission" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					  SELECT  P.*, Org.OrgUnitName
					  FROM    Ref_ParameterMission P, 
					          Organization.dbo.Organization Org
					  WHERE   P.ReceiptOrgUnit = Org.OrgUnit
					  AND     P.Mission = '#mis#'
					  AND     Org.Mission = '#mis#' 
					</cfquery>
           		   

					<cfquery name="qItem" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					  SELECT  *
					  FROM    Item
					  WHERE   ItemNo = '#Form.ItemNo#' 
					</cfquery>
					
					<cfset Category = qItem.Category>
					<cfset curr = APPLICATION.BaseCurrency>
					           	
                    <cfquery name="Journal" 
                      datasource="appsMaterials" 
                      username="#SESSION.login#" 
                      password="#SESSION.dbpw#">
                      SELECT    *
                         FROM      Accounting.dbo.Journal
                         WHERE     Mission       = '#mis#' 
                         AND       SystemJournal = 'Asset'
                         AND       Currency      = '#curr#' 
                    </cfquery>
                  
                   <cfif Journal.recordcount eq "0">
                         
                         <cf_waitEnd>                                    
                         <cf_message message = "#msg1# #msg2#" return = "back">
                         <cfabort>
       
                  </cfif>  
                                                           
                   <cf_GledgerEntryHeader
                          		Datasource            = "appsMaterials"
                                Mission               = "#mis#"
                             	OrgUnitOwner          = "#Mission.ReceiptOrgUnit#"
                             	Journal               = "#Journal.Journal#"
                                Description           = "#Form.Description#"
                                TransactionSource     = "AssetSeries"
                                TransactionCategory   = "Memorial"
                                MatchingRequired      = "0"
                                Reference             = "Receipt"       
                                ReferenceName         = "#Mission.OrgUnitName#"
                                ReferenceId           = "#URL.AssetId#"
                                ReferenceNo           = "#Form.ItemNo#"
                                DocumentCurrency      = "#curr#"
                                DocumentDate          = "#DateFormat(now(),CLIENT.DateFormatShow)#"
                                DocumentAmount        = "#price#"
                                ParentJournal         = ""
                                ParentJournalSerialNo = "">
     
                  <!--- Lines asset --->
                         
                   <!--- ---------------------- ---> 
                   <!--- define account receipt --->
                  <!--- ---------------------- --->
                  
                  
                  <cfquery name="Class" 
                     datasource="appsMaterials" 
                     username="#SESSION.login#" 
                     password="#SESSION.dbpw#">
                     SELECT    *
                     FROM      Ref_CategoryGledger
                        WHERE     Category = '#Category#'
                        AND       (Mission  = '#mis#' or Mission is NULL) 
                        AND       Area = 'InitialStock' 
                        AND       GLAccount IN (SELECT GLAccount 
                                                FROM Accounting.dbo.Ref_Account)
                 </cfquery>
                 
                  <cfset GLReceipt = Class.GLAccount>
                         
                   <!--- define account asset --->
                         
                          <cfquery name="Class" 
                             datasource="appsMaterials" 
                             username="#SESSION.login#" 
                             password="#SESSION.dbpw#">
                             SELECT    *
                             FROM      Ref_CategoryGledger
                                WHERE     Category = '#Category#'
                                AND       (Mission  = '#mis#' or Mission is NULL) 
                                AND       Area     = 'Stock' 
                                AND       GLAccount IN (SELECT GLAccount 
                                                 FROM Accounting.dbo.Ref_Account)
                         </cfquery>
                         
                         <cfset GLAsset = Class.GLAccount>
                         
                         <cfif GLAsset eq "" or GLReceipt eq "">
                                  
                                 <cf_message message = "#msg3# #Category#." return = "back">
                                 <cfabort>
                                                                                                                                
                         <cfelse>             
                                                                                                     
                                <cf_GledgerEntryLine
                                    Datasource            = "appsMaterials"
                                       Lines                 = "2"
                                       Journal               = "#Journal.Journal#"
                                       JournalNo             = "#JournalTransactionNo#"
                                       Currency              = "#curr#"
                                       
                                       TransactionSerialNo1  = "1"
                                       Class1                = "Debit"
                                       Reference1            = "Receipt"       
                                       ReferenceName1        = "#Mission.OrgUnitName#"
                                       Description1          = ""
                                       GLAccount1            = "#GLAsset#"
                                       Costcenter1           = "#Mission.ReceiptOrgUnit#"
                                       ProgramCode1          = ""
                                       ProgramPeriod1        = ""
                                       ReferenceId1          = "#URL.AssetId#"
                                       ReferenceNo1          = "#Form.ItemNo#"
                                       TransactionType1      = "Standard"
                                       Amount1               = "#price#"
                                       
                                       TransactionSerialNo2  = "2"
                                       Class2                = "Credit"
                                       Reference2            = "Receipt"       
                                       ReferenceName2        = "#Mission.OrgUnitName#"
                                       Description2          = ""
                                       GLAccount2            = "#GLReceipt#"
                                       Costcenter2           = "#Mission.ReceiptOrgUnit#"
                                       ProgramCode2          = ""
                                       ProgramPeriod2        = ""
                                       ReferenceId2          = "#URL.AssetId#"
                                       ReferenceNo2          = "#Form.ItemNo#"
                                       TransactionType2      = "Standard"
                                       Amount2               = "#price#">
                                       
                         </cfif>              
                         
                   </cfif>             


	  
	  </cftransaction>
			  
</cfif>			  
	
<cfoutput>    
	
	<script>		    
		try { window.dialogArguments.opener.refreshlist() } catch(e) {}
		parent.ColdFusion.navigate('../AssetEntry/AssetEdit.cfm?assetid=#url.assetid#','contentbox1')
	</script>	
	
</cfoutput>		


	
