﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	МодульВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта_Основной = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	НастройкиВарианта_Основной.Описание = НСтр("ru = 'Выводит результаты проверок учета.'");
	НастройкиВарианта_Основной.НастройкиДляПоиска.КлючевыеСлова = НСтр("ru = 'Отчет о проблемах объекта'");
	
КонецПроцедуры

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
Процедура ПриНастройкеВариантовОтчетов(Настройки) Экспорт
	
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РезультатыПроверкиУчета);
	ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.РезультатыПроверкиУчета).Включен = Ложь;
	
КонецПроцедуры

// См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.
Процедура ПередДобавлениемКомандОтчетов(КомандыОтчетов, НастройкиФормы, СтандартнаяОбработка) Экспорт
	
	Если Не ПравоДоступа("Просмотр", Метаданные.Отчеты.РезультатыПроверкиУчета) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не СтрНачинаетсяС(НастройкиФормы.ИмяФормы, Метаданные.Справочники.ПравилаПроверкиУчета.ПолноеИмя()) Тогда
		Возврат;
	КонецЕсли;
	
	Команда                   = КомандыОтчетов.Добавить();
	Команда.Представление     = НСтр("ru = 'Результаты проверки учета'");
	Команда.ИмяПараметраФормы = "";
	Команда.Важность          = "СмТакже";
	Команда.КлючВарианта      = "Основной";
	Команда.Менеджер          = "Отчет.РезультатыПроверкиУчета";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли
