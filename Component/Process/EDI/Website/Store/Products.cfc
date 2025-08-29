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
<cfcomponent displayname="ProsisReact Shipping" hint="Prosis React Store and customer management">

	<cffunction name="trackUser" access="remote" returnType="void">
		<cfargument name="account" 		Required=false default="">
		<cfargument name="host" 		Required=false default="">
		<cfargument name="sessionNo" 	Required=false default="">
		<cfargument name="group" 		Required=false default="">
		<cfargument name="PathName" 	Required=false default="">
		<cfargument name="FileName" 	Required=false default="">
		<cfargument name="Mission" 		Required=false default="">
		<cftry>
			<cfif len(CGI.HTTP_USER_AGENT) gte 200>
				<cfset bws = left(CGI.HTTP_USER_AGENT,200)>
			<cfelse>
				<cfset bws = CGI.HTTP_USER_AGENT>
			</cfif>

			<cfif account eq "null">
				<cfset account = "">
			</cfif>

			<cfquery name="insertLog"
					datasource="AppsSystem">
					INSERT INTO UserStatusLog
					(Account,
					HostName,
					NodeIP,
					NodeVersion,
					HostSessionNo,
					ActionTimeStamp,
					ActionTemplate,
					ActionQueryString,
					TemplateGroup,
					PathName,
					FileName,
					SystemFunctionId,
					Mission)
					VALUES
					('#account#',
					 '#host#',
					'#CGI.Remote_Addr#',
					'#bws#',
					'#sessionNo#',
					getDate(),
					'#CGI.SCRIPT_NAME#',
					'#CGI.QUERY_STRING#',
					'#group#',
					'#PathName#',
					'#FileName#',
					NULL,
					'#Mission#'
			)
			</cfquery>

			<cfcatch></cfcatch>

		</cftry>
	</cffunction>

	<cffunction name="getAll" access="remote" hint="send a websocket message" returnType="void">
		
		<cfargument name="mission" 				Required=false default="BAMBINO">
		<cfargument name="warehouse" 			Required=false default="BAM03"> <!--- Default: Sucursal (BAM03) --->
		<cfargument name="PriceSchedule" 		Required=false default="">
		<cfargument name="category" 			Required=false default="">
		<cfargument name="categoryItem" 		Required=false default="">
		<cfargument name="currency" 			Required=false default="QTZ">
		<cfargument name="itemNo" 				Required=false default="">
		<cfargument name="searchText" 			Required=false default="">
		<cfargument name="selectTopN" 			Required=false default="">
		<cfargument name="onSale" 				Required=false default="0">
		<cfargument name="orderBy" 				Required=false default="">
		<cfargument name="account" 				Required=false default="">

		<cfset trackUser(arguments.account,'tienda','','#categoryItem#','#category#','#searchText#','#mission#')>
		<cfheader name="Access-Control-Allow-Origin" value="*">

		<cfset vSearchText = trim(searchText)>

		<cfquery name="qItems" datasource="AppsMaterials">
			<cfif trim(selectTopN) eq "">
				SELECT 	*
			<cfelse>
				SELECT TOP #trim(selectTopN)# *
			</cfif>
			FROM (	SELECT 	I.Category,
							I.CategoryItem,
							C.Description as CategoryDescription,
							CI.CategoryItemName,
							I.ItemDescription,
							I.ItemNo,
							IU.UoM,
							IU.UoMDescription,
							I.ItemPrecision,
							I.ItemNoExternal,
							M.FieldDefault,
							M.PriceSchedule,
							M.PriceScheduleDescription,
							M.Currency,
							CU.CurrencySymbol,
							M.PriorPrice,
							M.SalesPrice,
							M.PriceDate,
							M.PriceOffPercentage,
							M.PriceOff,
							ISNULL((
								SELECT	IWx.MinReorderQuantity
								FROM	ItemWarehouse IWx WITH (NOLOCK) 
								WHERE	IWx.ItemNo = IU.ItemNo
								AND		IWx.UoM = IU.UoM
								AND		IWx.Warehouse = '#arguments.warehouse#' -- Param: Warehouse
							), 0) AS OfferMinimumQuantity,
							ISNULL((   
								SELECT ROUND(SUM(ITx.TransactionQuantity),5)
								FROM   ItemTransaction ITx WITH (NOLOCK)
								WHERE  ITx.ItemNo = I.ItemNo
								AND    ITx.Mission = MI.Mission
								AND    ITx.WorkorderId IS NULL
								AND    ITx.TransactionId NOT IN	
										(
											SELECT	Ix.TransactionId
											FROM	Warehouse AS Wx WITH (NOLOCK)
													INNER JOIN ItemTransaction AS Ix WITH (NOLOCK)
														ON Wx.Warehouse = Ix.Warehouse 
														AND Wx.LocationReceipt = Ix.Location
											WHERE	Ix.TransactionType = '1' 
											AND		Ix.TransactionId NOT IN 
													(SELECT ITVx.TransactionId FROM ItemTransactionValuation AS ITVx WITH (NOLOCK)) 
										)
							), 0) as OnHand
						
					FROM	Item I WITH (NOLOCK)
							INNER JOIN Ref_Category C WITH (NOLOCK)
								ON I.Category = C.Category
							INNER JOIN Ref_CategoryItem CI WITH (NOLOCK)
								ON CI.Category = I.Category 
								AND CI.CategoryItem = I.CategoryItem
							INNER JOIN ItemUoM IU WITH (NOLOCK)
								ON IU.ItemNo = I.ItemNo 
							INNER JOIN ItemUoMMission MI WITH (NOLOCK)
								ON MI.ItemNo = I.ItemNo
							INNER JOIN skMissionItemPrice M WITH (NOLOCK)
								ON M.Mission = MI.Mission
								AND M.ItemNo = IU.ItemNo
								AND M.UoM = IU.UoM
								AND M.Currency = '#arguments.Currency#' -- Param: Currency
								<cfif trim(arguments.PriceSchedule) eq "">
									AND M.FieldDefault = 1
								<cfelse>
									AND M.PriceSchedule = '#arguments.PriceSchedule#' -- Param: PriceSchedule
								</cfif>
							INNER JOIN Accounting.dbo.Currency CU WITH (NOLOCK)
								ON CU.Currency = M.Currency
					WHERE	MI.Mission       = '#arguments.mission#' -- Param: Mission
					AND		IU.EnablePortal  = '1'

					--With pictures
					AND		EXISTS (
								SELECT	'X'
								FROM	ItemImage Ix WITH (NOLOCK)
								WHERE	Ix.ItemNo = I.ItemNo
								AND		Ix.ImageClass = '001' --No thumbnails
							)

					<cfif trim(arguments.onSale) eq "1">
						--On sale items
						AND 	M.Promotion = 1
						AND 	M.PriorPrice > 0
					</cfif>
			
					<cfif trim(arguments.itemno) neq "">
						AND    I.ItemNo = '#arguments.itemno#'
					<cfelse>
						<cfif vSearchText neq "">
							AND 
							(
								<cf_softlike left="I.ItemDescription" 	right="#vSearchText#" language="ESP">
								OR
								<cf_softlike left="CI.CategoryItemName" right="#vSearchText#" language="ESP">
								OR
								<cf_softlike left="C.Description" 		right="#vSearchText#" language="ESP">
								OR
								I.ItemNo = '#vSearchText#'
								OR
								I.itemNoExternal like '%#vSearchText#%'
								OR
								I.ItemNo IN (SELECT Ux.ItemNo FROM ItemUoM Ux WHERE Ux.ItemBarcode like '%#vSearchText#%')
							)
						<cfelseif arguments.category neq "">
							AND I.Category = '#arguments.category#'
						<cfelseif arguments.CategoryItem neq "">
							AND CI.CategoryItem = '#arguments.CategoryItem#'
						</cfif>
					</cfif>

					) as XL

			WHERE  OnHand > 0

			ORDER BY 	
				<cfswitch expression="#arguments.OrderBy#">
					<cfcase value="stockASC">
						OnHand DESC
					</cfcase>
					<cfcase value="stockDESC">
						OnHand ASC
					</cfcase>
					<cfcase value="descASC">
						ItemDescription ASC
					</cfcase>
					<cfcase value="descDESC">
						ItemDescription DESC
					</cfcase>
					<cfcase value="catASC">
						CategoryDescription ASC
					</cfcase>
					<cfcase value="catDESC">
						CategoryDescription DESC
					</cfcase>
					<cfcase value="priceASC">
						SalesPrice ASC
					</cfcase>
					<cfcase value="priceDESC">
						SalesPrice DESC
					</cfcase>
					<cfcase value="discountASC">
						PriceOffPercentage ASC
					</cfcase>
					<cfcase value="discountDESC">
						PriceOffPercentage DESC
					</cfcase>
					<cfdefaultcase>
						ItemDescription ASC
					</cfdefaultcase>
				</cfswitch>

		</cfquery>

		<cfset result = QueryToArray(qItems)>

		<cfloop array="#result#" item="itm">
		
			<cfquery name="qImages" datasource="AppsMaterials">
				SELECT 	*
				FROM 	ItemImage WITH (NOLOCK)
				WHERE 	ItemNo = '#itm.itemNo#'
				AND		ImageClass = '001' --No thumbnails
				ORDER BY ImageSerialNo ASC
			</cfquery>

			<cfset itm.picture = arrayNew(1)>
			<cfloop query="#qImages#">
				<cfset thisFile= "D:\Prosis\CHARLIE\Document\#qImages.ImagePath#">
				<cfset vFile = "">
				<cfif (FileExists(thisFile))>
					<cfset vFile = Replace(qImages.ImagePath,'Warehouse/Pictures/','')>
					<cfset itm.picture[CurrentRow]=vFile>
				</cfif>
			</cfloop>

		</cfloop>

		<cfscript>
			threadName = "ws_msg_" & createUUID();
			products = structnew("ordered");
			products.products = result;
			msg = SerializeJSON(products);
			msg = replace(msg,"//","","one");
			cfthread(action:"run",name:threadName,message:msg) {
				WsPublish("prosis",attributes.message);
			}
			writeOutput(msg);
		</cfscript>
	</cffunction>
	

  	<cffunction name="getCategories" access="remote" hint="send a websocket message" returnType="void">
	
	    <cfargument name="Mission"    Required="false" default="Bambino">
		<cfargument name="SearchText" Required="false" default="">
		<cfargument name="Category"   Required="false" default="">
		<cfargument name="OrderBy"    Required="false" default="">
		<cfargument name="account"    Required="false" default="">

		<!--- tracking user ---> 
		<cfset trackUser(arguments.account,'tienda','','','#category#','#searchText#','#mission#')>
		<cfheader name="Access-Control-Allow-Origin" value="*">

		<cfquery name="qCategoriesBase" datasource="AppsMaterials">
			SELECT	*
			FROM	(
						SELECT 	C.Category,
								C.Description as CategoryDescription,
								C.Image as CategoryImage,
								C.TabOrder as CategoryOrder,
								CI.CategoryItem,
								CI.CategoryItemName,
								ISNULL((   
									SELECT ROUND(SUM(ITx.TransactionQuantity),5)
									FROM   ItemTransaction ITx WITH (NOLOCK)
									WHERE  ITx.ItemNo   = I.ItemNo
									AND    ITx.Mission  = MI.Mission
									AND    ITx.Warehouse IN (SELECT Warehouse FROM Warehouse WHERE WarehouseClass = '002')
									AND    ITx.WorkorderId IS NULL
									AND    ITx.TransactionId NOT IN	(
												SELECT	Ix.TransactionId
												FROM	Warehouse AS Wx WITH (NOLOCK)
														INNER JOIN ItemTransaction AS Ix WITH (NOLOCK)
															ON Wx.Warehouse = Ix.Warehouse 
															AND Wx.LocationReceipt = Ix.Location
												WHERE	Ix.TransactionType = '1' 
												AND		Ix.TransactionId NOT IN (SELECT ITVx.TransactionId FROM ItemTransactionValuation AS ITVx WITH (NOLOCK)) 
											)
								), 0) as OnHand
									
						FROM	Item I WITH (NOLOCK)
								INNER JOIN Ref_Category C WITH (NOLOCK)
									ON I.Category = C.Category
								INNER JOIN Ref_CategoryItem CI WITH (NOLOCK)
									ON CI.Category = I.Category 
									AND CI.CategoryItem = I.CategoryItem
								INNER JOIN ItemUoM IU WITH (NOLOCK)
									ON IU.ItemNo = I.ItemNo 
								INNER JOIN ItemUoMMission MI WITH (NOLOCK)
									ON MI.ItemNo = I.ItemNo
						WHERE	MI.Mission       = '#arguments.Mission#' -- Param: Mission
						AND		IU.EnablePortal  = '1'
						AND  	C.Operational = '1'

						--With pictures
						AND		EXISTS (
									SELECT	'X'
									FROM	ItemImage Ix WITH (NOLOCK)
									WHERE	Ix.ItemNo = I.ItemNo
									AND		Ix.ImageClass = '001' --No thumbnails
								)
					) AS Base
			WHERE	Base.OnHand > 0
			
			<cfif trim(Category) neq "">
			AND     Base.Category = '#Category#'
			</cfif>
			
			<cfif trim(SearchText) neq "">
			AND    <cf_softlike left="Base.CategoryDescription" right="#trim(SearchText)#" language="ESP">
			</cfif>

		</cfquery>

		<cfquery name="qCategories" dbtype="query">
			SELECT DISTINCT Category, CategoryDescription, CategoryImage, CategoryOrder
			FROM 	qCategoriesBase
			ORDER BY 	<cfswitch expression="#OrderBy#">
							<cfcase value="asc">
								CategoryOrder ASC
							</cfcase>
							<cfcase value="desc">
								CategoryOrder DESC
							</cfcase>
							<cfdefaultcase>
								CategoryOrder ASC
							</cfdefaultcase>
						</cfswitch>
		</cfquery>
		
		<cfset result = QueryToArray(qCategories)>
		
		<cfloop array="#result#" item="itm">

			<cfquery name="qSubCategories" dbtype="query">
				SELECT DISTINCT CategoryItem, CategoryItemName
				FROM 	qCategoriesBase
				WHERE 	Category  = '#itm.Category#'
				ORDER BY CategoryItemName ASC
			</cfquery>
						
			<cfset itm.subcategories = arrayNew(1)>
			<cfloop query="#qSubcategories#">
				<cfset itm.subcategories[CurrentRow]["categoryitem"]=qSubcategories.categoryitem>
				<cfset itm.subcategories[CurrentRow]["categoryitemname"]=qSubcategories.categoryitemname>
			</cfloop>							
			
		</cfloop>
		
		<cfscript>
		
			threadName = "ws_msg_" & createUUID();			
			categories = structnew("ordered");
			categories.categories = result;			
			msg = SerializeJSON(categories);
			msg = replace(msg,"//","","one");
			cfthread(action:"run",name:threadName,message:msg){
				WsPublish("prosis",attributes.message);
			}
			writeOutput(msg);
			
		</cfscript>
		
  	</cffunction>

 	<cffunction name="QueryToArray" access="private" hint="transpose query object to something more serializable">
		<!--- ray camden first wrote one of these functions, props to him --->
		<cfargument type="query" name="q">
			<cfset result = ArrayNew(1)>
			<cfset cols = q.columnList>
			<cfset colsLen = listLen(cols)>
			<cfloop from="1" to="#q.recordCount#" index="i">
				<cfset struct = {}>
				<cfloop from="1" to="#colsLen#" index="k">
					<cfset struct[lcase(listGetAt(cols, k))] = q[listGetAt(cols, k)][i]>
				</cfloop>
				<cfset tmp = ArrayAppend(result, struct)>
			</cfloop>
		<cfreturn result>
  	</cffunction>

	<cffunction name="mobilePwdReset"
			access="remote"
			hint="send a websocket message"
			returnformat="json"
			returnType="any">

		<cfargument name="email" 	type="string" required="true" default="">
		<cfheader name="Access-Control-Allow-Origin" value="*">

		<cfset SESSION.login             = "sa">
		<cfset SESSION.dbpw              = "621*/4106">
		<cfset client.PersonNo           = "000">
		<cfset session.acc               = "admin">
		<cfset session.last              = "admin">
		<cfset session.first             = "admin">
		<cfset session.authent           = "1">
		<cfset APPLICATION.DateFormat    = "dd/mm/YYYY">
		<Cfset APPLICATION.DateFormatSQL = "YYYY-mm-dd">
		<cfset APPLICATION.BaseCurrency  = "QTZ">
		<cfset client.dateformatshow     = "dd/mm/YYYY">

		<cfinvoke component="Service.Access.MobileAccess"
			Method            = "PasswordReset"
			Email             = "#trim(arguments.email)#"
			Welcome           = "Charlie Internacional"
			Root              = "https://tienda.charlieinternacional.com/"
			returnvariable    = "functionResult">

		<cfset SESSION.login    = "">
		<cfset SESSION.dbpw     = "">
		<cfset client.PersonNo  = "000">
		<cfset session.acc      = "admin">
		<cfset session.last     = "admin">
		<cfset session.first    = "admin">
		<cfset session.authent  = "0">

		<!---
		0 : Error - Email does not exist
		1 : OK
		--->

		<cfset qResponse = QueryNew("Status", "Varchar")>

		<cfset temp = QueryAddRow(qResponse)>
		<cfset Temp = QuerySetCell(qResponse, "Status", "#functionResult#")>

		<cfset result = QueryToArray(qResponse)>

		<cfscript>
			threadName = "ws_msg_" & createUUID();
			credentials = structnew("ordered");
			credentials = result;
			msg = SerializeJSON(credentials);
			msg = replace(msg,"//","","one");
			cfthread(action:"run",name:threadName,message:msg){
				WsPublish("prosis",attributes.message);
     		}
			writeOutput(msg);
		</cfscript>

	</cffunction>

	<cffunction name="mobilePwdChange"
			access="remote"
			hint="send a websocket message"
			returnformat="json"
			returnType="any">

			<cfargument name="user" 	    type="string" required="true" default="">
			<cfargument name="OldPwd" 		type="string" required="true" default="">
			<cfargument name="Pwd1" 		type="string" required="true" default="">
			<cfargument name="Pwd2" 		type="string" required="true" default="">
			
			<cfheader name="Access-Control-Allow-Origin" value="*">
	
			<cfset SESSION.login = "sa">
			<cfset SESSION.dbpw = "621*/4106">
			<cfset client.PersonNo = "000">
			<cfset session.acc = "admin">
			<cfset session.last = "admin">
			<cfset session.first = "admin">
			<cfset session.authent = "1">
			<cfset APPLICATION.DateFormat = "dd/mm/YYYY">
			<Cfset APPLICATION.DateFormatSQL = "YYYY-mm-dd">
			<cfset APPLICATION.BaseCurrency = "QTZ">
			<cfset client.dateformatshow = "dd/mm/YYYY">
	
			<cfinvoke component="Service.Access.MobileAccess"
					Method             = "PasswordChange"
					Account            = "#user#"
					OldPwd             = "#OldPwd#"
					Pwd1               = "#Pwd1#"
					Pwd2               = "#Pwd2#"
					MinLength          = "8"
					SendMail           = "yes"
					Welcome            = "Charlie Internacional"
					Root               = "https://tienda.charlieinternacional.com/"
					returnvariable     = "functionResult">

			<cfset SESSION.login = "">
			<cfset SESSION.dbpw = "">
			<cfset client.PersonNo = "000">
			<cfset session.acc = "admin">
			<cfset session.last = "admin">
			<cfset session.first = "admin">
			<cfset session.authent = "0">

		<!---
		1 : OK
		2: Error - Account does not exist
		3: Error - Old password does not match
		4: Error - new/confirm not the same
		5: Error - new/old are the same
		--->

		<cfset qResponse = QueryNew("Status", "Varchar")>

		<cfset temp = QueryAddRow(qResponse)>
		<cfset Temp = QuerySetCell(qResponse, "Status", "#functionResult#")>

		<cfset result = QueryToArray(qResponse)>

		<cfscript>
			threadName = "ws_msg_" & createUUID();
			credentials = structnew("ordered");
			credentials = result;
			msg = SerializeJSON(credentials);
			msg = replace(msg,"//","","one");
			cfthread(action:"run",name:threadName,message:msg){
				WsPublish("prosis",attributes.message);
			}
			writeOutput(msg);
		</cfscript>

	</cffunction>
	

	<cffunction name="mobileLogin"
			access="remote"
			hint="send a websocket message"
			returnformat="json"
			returnType="any">

			<cfargument name="mission"  type="string" required="false" default="BAMBINO">		
			<cfargument name="callback" type="string" required="false">
			<cfargument name="user" 	type="string" required="true" default="">
			<cfargument name="pwd" 		type="string" required="true" default="">
			<cfargument name="deviceId" type="string" required="true" default="">
			<cfheader name="Access-Control-Allow-Origin" value="*">

			<cfinvoke component="Service.Access.MobileAccess"
					Method       		= "Authenticate"
					Account      		= "#user#"
					Pwd			   		= "#pwd#"
					DeviceId			= "#deviceId#"
					returnvariable   	= "functionResult">

			<cfset record = deserializeJSON(functionResult)>

					<cfquery name="qUserMission" datasource="AppsSystem">
					SELECT       C.CustomerId, U.Account,U.firstName+' '+U.lastName AS NAME, C.OrgUnit
					FROM         UserNames AS U 
					             INNER JOIN	Applicant.dbo.Applicant AS A ON U.PersonNo = A.PersonNo 
								 INNER JOIN Materials.dbo.Customer AS C ON A.PersonNo = C.PersonNo
					WHERE        C.Mission = '#mission#'
					AND          U.Account = '#record.Data.Account[1]#' 
					AND          C.Operational = 1 
					AND          U.Disabled = 0 
					AND          A.CandidateStatus = '1'
				</cfquery>

			<cfif qUserMission.recordcount neq 0>

			</cfif>
				
			<cfset result = QueryToArray(qUserMission)>

			<cfloop array="#result#" item="itm">

				<cfquery name="qAddress" datasource="AppsMaterials">
					SELECT  CA.AddressType, A.*
					FROM    CustomerAddress CA 
					        INNER JOIN System.dbo.Ref_Address A	ON CA.AddressId = A.AddressId
					WHERE   CA.CustomerId = '#qUserMission.CustomerId#'
				</cfquery>

				<cfset itm.address = arrayNew(1)>
				<cfloop query="#qAddress#">
					<cfset itm.address[CurrentRow]["AddressId"]=qAddress.AddressId>
					<cfset itm.address[CurrentRow]["AddressType"]=qAddress.AddressType>
					<cfset itm.address[CurrentRow]["Address"]=qAddress.Address>
					<cfset itm.address[CurrentRow]["Address2"]=qAddress.Address2>
					<cfset itm.address[CurrentRow]["AddressCity"]=qAddress.AddressCity>
					<cfset itm.address[CurrentRow]["Country"]=qAddress.Country>
				</cfloop>

				<cfquery name="qSchedule" datasource="AppsMaterials">
					SELECT     TOP (1) PriceSchedule
					FROM       CustomerSchedule AS T
					WHERE      CustomerId = '#qUserMission.CustomerId#'
					AND        DateEffective IN (SELECT     MAX(DateEffective) AS Expr1
								    		     FROM       CustomerSchedule
									  	         WHERE      CustomerId = T.CustomerId)
				</cfquery>

				<cfset itm.PriceSchedule = qSchedule.PriceSchedule>

			</cfloop>

			<cfscript>
				threadName = "ws_msg_" & createUUID();
				credentials = structnew("ordered");
				credentials = result;
				msg = SerializeJSON(credentials);
				msg = replace(msg,"//","","one");
				cfthread(action:"run",name:threadName,message:msg){
					WsPublish("prosis",attributes.message);
			    }
			    writeOutput(msg);
			</cfscript>

	</cffunction>

	<cffunction name     = "setAnonymous"
			access       = "remote"
			hint         = "send a websocket message"
			returnformat = "json"
			returnType   = "any">

		<cfargument name="deviceId" 	type="string" required="true" default="">
		<cfargument name="warehouse" 	type="string" required="true" default="">
		<cfargument name="mission" 		type="string" required="true" default="">
		<cfargument name="account" 		type="string" required="true" default="">

		<cfset trackUser(arguments.account,'tienda','','#warehouse#','Anonymous','','#mission#')>

		<cfheader name="Access-Control-Allow-Origin" value="*">

		<cfquery name="qCategoryItem" datasource="AppsMaterials">
			SELECT TOP 1 CategoryItem
			FROM   Ref_CategoryItem CI
			WHERE EXISTS ( SELECT 'X'
						   FROM Item I 
						   INNER JOIN ItemImage II ON II.ItemNo = I.ItemNo						   
						   INNER JOIN ItemUoM M    ON M.ItemNo = I.ItemNo
						   WHERE I.CategoryItem = CI.CategoryItem
						   AND   II.Created >= '2019-09-01'	)
			ORDER BY NEWID()
		</cfquery>

		<cfset categoryItem=qCategoryItem.CategoryItem>

		<cfquery name="qScheduleDefault"
				datasource="AppsMaterials">
			SELECT Code as DefaultPriceSchedule, W.Country, W.Address, W.City, W.Telephone, W.Fax, W.Contact, '#categoryItem#' as CategoryItem
			FROM   Ref_PriceSchedule S, Warehouse W
			WHERE  S.FieldDefault = '1'
			AND    W.Warehouse    = '#arguments.warehouse#'
		</cfquery>

		<cfset result = QueryToArray(qScheduleDefault)>

		<cfscript>
			threadName = "ws_msg_" & createUUID();
			credentials = structnew("ordered");
			credentials = result;
			msg = SerializeJSON(credentials);
			msg = replace(msg,"//","","one");
			cfthread(action:"run",name:threadName,message:msg){
				WsPublish("prosis",attributes.message);
			}
			writeOutput(msg);
		</cfscript>

	</cffunction>
		

	<cffunction name     = "getQuotes"
			access       = "remote"
			hint         = "send a websocket message"
			returnformat = "json"
			returnType   = "any">

	    <cfargument name="mission" 		type="string" required="false" default="BAMBINO">	
		<cfargument name="warehouse" 	type="string" required="true" default="">	 
		<cfargument name="customerId" 	type="string" required="true" default="">
			
		<cfheader name="Access-Control-Allow-Origin" value="*">

		<cfquery name="qQuotes" datasource="AppsMaterials">
			SELECT 	L.*, 
					U.UoMDescription, 
					I.ItemNoExternal,
					C.Description as CategoryDescription
			FROM 	CustomerRequest R
					INNER JOIN CustomerRequestLine L   ON R.RequestNo = L.RequestNo 
					INNER JOIN ItemUoM U 			   ON U.ItemNo = L.ItemNo AND U.UoM = L.TransactionUoM 
					INNER JOIN Item I 				   ON I.ItemNo = U.ItemNo
					INNER JOIN Ref_Category C   	   ON I.Category = C.Category
			WHERE 	R.CustomerId = '#arguments.customerId#'
			AND 	R.BatchNo IS NULL
			AND 	R.ActionStatus != '9'
			<cfif arguments.mission neq "">
			AND  	R.Mission = '#arguments.mission#'
			</cfif>
		</cfquery>

		<cfset result = QueryToArray(qQuotes)>

		<cfscript>
			threadName = "ws_msg_" & createUUID();
			credentials = structnew("ordered");
			credentials = result;
			msg = SerializeJSON(credentials);
			msg = replace(msg,"//","","one");
			cfthread(action:"run",name:threadName,message:msg){
				WsPublish("prosis",attributes.message);
			}
			writeOutput(msg);
		</cfscript>

	</cffunction>

	<cffunction name="postOrder"
			access="remote"
			returnformat="json"
			returnType="any">

		<cfargument name="cart" type="string" required="true">

		<cfheader name="Access-Control-Allow-Origin" value="*">

		<cfset SESSION.login = "sa">
		<cfset SESSION.dbpw = "621*/4106">
		<cfset client.PersonNo = "000">
		<cfset session.acc = "admin">
		<cfset session.last = "admin">
		<cfset session.first = "admin">
		<cfset session.authent = "1">
		<cfset APPLICATION.DateFormat = "dd/mm/YYYY">
		<Cfset APPLICATION.DateFormatSQL = "YYYY-mm-dd">
		<cfset APPLICATION.BaseCurrency = "QTZ">
		<cfset client.dateformatshow = "dd/mm/YYYY">

		<cfinvoke component = "Service.Process.EDI.website.store.Request"
			method           = "addCart"
			cart             = "#Cart#"
			returnvariable   = "postResult">

		<cfset SESSION.login = "">
		<cfset SESSION.dbpw = "">
		<cfset client.PersonNo = "000">
		<cfset session.acc = "admin">
		<cfset session.last = "admin">
		<cfset session.first = "admin">
		<cfset session.authent = "0">

		<cfset qResponse = QueryNew("Status,Description,PostResult", "Varchar,Varchar,Varchar")>

		<cfset temp = QueryAddRow(qResponse)>
		<cfset Temp = QuerySetCell(qResponse, "Status", "OK")>
		<cfset Temp = QuerySetCell(qResponse, "Description", "OK")>
		<cfset Temp = QuerySetCell(qResponse, "PostResult", postResult)>

		<cfset result = QueryToArray(qResponse)>

		<cfscript>
			threadName = "ws_msg_" & createUUID();

			credentials = structnew("ordered");
			credentials.result = result;

			msg = SerializeJSON(credentials);
			msg = replace(msg,"//","","one");

			cfthread(action:"run",name:threadName,message:msg) {
				WsPublish("prosis",attributes.message);
			}

			writeOutput(msg);
		</cfscript>

	</cffunction>


</cfcomponent>