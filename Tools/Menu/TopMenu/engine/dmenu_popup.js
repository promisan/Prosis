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
//***********************************************
//  Javascript Menu (c) 2006, by Deluxe-Menu.com
//  version 2.0
//  E-mail:  dev@email
//***********************************************


function _dmie(event){var x=0,y=0;if(_e||_o){x=event.clientX+(_ec?dde.scrollLeft:0);y=event.clientY+(_ec?dde.scrollTop:0);}else{x=event.pageX;y=event.pageY;};return[x,y];};function dm_popup(mi,dhp,event,x,y){if(_e)event.returnValue=false;var dm=_dm[mi],ce=dm.m[1],xy=(x&&y)?[x,y]:_dmie(event);if(ce){var oo=_dmni(ce);if(oo.style.visibility=='visible'){clearTimeout(dm._dmnl);_dmmh(dm.m[0].sh);window.status='';};dm.m[0].sh=ce.id;_dmzh(ce.id);var dsd=_dmcs(dm),cc=_dmos(_dmoi(ce.id+'tbl'));with(ce){var w=(ct.smW?parseInt(ct.smW):cc[2])+shadowLen,h=(ct.qhi?parseInt(ct.qhi):cc[3])+shadowLen;};xy[0]=_dmoz(xy[0],w,0,dsd[2]+dsd[0],0);xy[1]=_dmoz(xy[1],h,0,dsd[3]+dsd[1],0);with(oo.style){left=xy[0]+du;top=xy[1]+du;};if(dhp>0)dm._dmnl=setTimeout("_dmmh('"+dm.m[0].sh+"');window.status='';",dhp);};return false;};
