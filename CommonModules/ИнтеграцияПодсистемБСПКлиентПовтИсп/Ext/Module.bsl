﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////


#Область СлужебныйПрограммныйИнтерфейс

Функция ПодпискиБТС() Экспорт
	
	Подписки = ИнтеграцияПодсистемБСПКлиент.СобытияБСП();
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность") Тогда
		МодульИнтеграцияПодсистемБТСКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБТСКлиент");
		МодульИнтеграцияПодсистемБТСКлиент.ПриОпределенииПодписокНаСобытияБСП(Подписки);
	КонецЕсли;
	
	Возврат Подписки;
	
КонецФункции

Функция ПодпискиБИП() Экспорт
	
	Подписки = ИнтеграцияПодсистемБСПКлиент.СобытияБСП();
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		МодульИнтеграцияПодсистемБИПКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияПодсистемБИПКлиент");
		МодульИнтеграцияПодсистемБИПКлиент.ПриОпределенииПодписокНаСобытияБСП(Подписки);
	КонецЕсли;
	
	Возврат Подписки;
	
КонецФункции

#КонецОбласти