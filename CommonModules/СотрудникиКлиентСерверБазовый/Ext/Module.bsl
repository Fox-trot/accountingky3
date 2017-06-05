﻿////////////////////////////////////////////////////////////////////////////////
// СотрудникиКлиентСерверБазовый: методы, обслуживающие работу формы сотрудника
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Работа с дополнительными формами

Функция ОписаниеДополнительнойФормы(ИмяОткрываемойФормы) Экспорт
	
	ОписаниеФормы = СотрудникиКлиентСервер.ОбщееОписаниеДополнительнойФормы(ИмяОткрываемойФормы);
	
	Если ИмяОткрываемойФормы = "Справочник.Сотрудники.Форма.ЛичныеДанные" Тогда
		
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ФизическоеЛицоСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("СозданиеНового");
		
		ОписаниеФормы.РеквизитыОбъекта.Вставить("ФизическоеЛицоДатаРегистрации", "ФизическоеЛицо.ДатаРегистрации");
		ОписаниеФормы.РеквизитыОбъекта.Вставить("ФизическоеЛицоМестоРождения", "ФизическоеЛицо.МестоРождения");
		ОписаниеФормы.РеквизитыОбъекта.Вставить("ФизическоеЛицоКонтактнаяИнформация", "ФизическоеЛицо.КонтактнаяИнформация");
		ОписаниеФормы.РеквизитыОбъекта.Вставить("ФизическоеЛицоДатаРегистрации", "ФизическоеЛицо.ДатаРегистрации");

		ОписаниеФормы.ДополнительныеДанные.Вставить("ГражданствоФизическихЛиц");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ГражданствоФизическихЛицНаборЗаписей");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ГражданствоФизическихЛицНаборЗаписейПрочитан");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ГражданствоФизическихЛицНоваяЗапись");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ГражданствоФизическихЛицПрежняя");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ДокументыФизическихЛиц");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ДокументыФизическихЛицНаборЗаписей");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ДокументыФизическихЛицНаборЗаписейПрочитан");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ДокументыФизическихЛицНоваяЗапись");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ДокументыФизическихЛицПрежняя");
		
	ИначеЕсли ИмяОткрываемойФормы = "Справочник.Сотрудники.Форма.ВыплатаЗарплаты" Тогда
		
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("СотрудникСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ТекущаяОрганизация");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("СозданиеНового");
		
		ОписаниеФормы.ДополнительныеДанные.Вставить("ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамНаборЗаписей");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамНаборЗаписейПрочитан");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамНоваяЗапись");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПрежняя");
		
	ИначеЕсли ИмяОткрываемойФормы = "Справочник.Сотрудники.Форма.УчетЗатрат" Тогда
		
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("СотрудникСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ДатаПриема");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("СозданиеНового");
		
		ОписаниеФормы.ДополнительныеДанные.Вставить("БухучетЗарплатыСотрудников");
		ОписаниеФормы.ДополнительныеДанные.Вставить("БухучетЗарплатыСотрудниковНаборЗаписей");
		ОписаниеФормы.ДополнительныеДанные.Вставить("БухучетЗарплатыСотрудниковНаборЗаписейПрочитан");
		ОписаниеФормы.ДополнительныеДанные.Вставить("БухучетЗарплатыСотрудниковНоваяЗапись");
		ОписаниеФормы.ДополнительныеДанные.Вставить("БухучетЗарплатыСотрудниковПрежняя");
		
	ИначеЕсли ИмяОткрываемойФормы = "Справочник.Сотрудники.Форма.НалогНаДоходы" Тогда
		
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("СотрудникСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ФизическоеЛицоСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ТекущаяОрганизация");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ДатаПриема");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("СозданиеНового");
		
		ОписаниеФормы.ДополнительныеДанные.Вставить("СтатусыСотрудниковНДФЛ");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СтатусыСотрудниковНДФЛНаборЗаписей");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СтатусыСотрудниковНДФЛНаборЗаписейПрочитан");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СтатусыСотрудниковНДФЛНоваяЗапись");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СтатусыСотрудниковНДФЛПрежняя");
		
	КонецЕсли;
	
	Возврат ОписаниеФормы;
	
КонецФункции

