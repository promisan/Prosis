/*
 * Copyright © 2025 Promisan B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
//Global data variables
var globalDataList 			= '';
var globalCustomerList		= '';
var globalPicturesList		= '';
var globalPersonsList		= '';

var globalParentCustomerObj = {};
var globalCustomerObj 		= {};
var globalClassObj			= {};
var globalAreaObj			= {};
var globalHourObj			= {};
var globalPersonObj			= {};

var globalISOSelectedDate	= "";
var globalSTRSelectedDate	= "";

var globalScrollTimer		= null;
var globalScrollDelay		= 500;

var $globalVisible;

var globalClickEvent		= 'mousedown';
var globalClickOutEvent		= 'mouseup';

//Detect a touch device
if (!!('ontouchstart' in window)) { //just for ie10 || !!('onmsgesturechange' in window)
	globalClickEvent		= 'touchstart';
	globalClickOutEvent		= 'touchend';
}
