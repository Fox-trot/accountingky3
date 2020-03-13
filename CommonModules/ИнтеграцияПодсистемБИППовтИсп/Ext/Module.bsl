﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция ПодпискиБСП() Экспорт
	
	Подписки = ИнтеграцияПодсистемБИП.СобытияБИП();
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы") Тогда
		МодульИнтеграцияПодсистемБСП = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияПодсистемБСП");
		МодульИнтеграцияПодсистемБСП.ПриОпределенииПодписокНаСобытияБИП(Подписки);
	КонецЕсли;
	
	Возврат Подписки;
	
КонецФункции

#КонецОбласти