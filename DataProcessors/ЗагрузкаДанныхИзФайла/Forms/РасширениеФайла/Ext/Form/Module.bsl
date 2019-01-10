﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	Если ТипСохраняемогоФайла = 0 Тогда 
		Результат = "xlsx";
	ИначеЕсли ТипСохраняемогоФайла = 1 Тогда
		Результат = "csv";
	ИначеЕсли ТипСохраняемогоФайла = 4 Тогда
		Результат = "xls";
	ИначеЕсли ТипСохраняемогоФайла = 5 Тогда
		Результат = "ods";
	Иначе
		Результат = "mxl";
	КонецЕсли;
	Закрыть(Результат);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДополнениеДляОблегченияРаботыСФайлами(Команда)
	НачатьУстановкуРасширенияРаботыСФайлами(Неопределено);
КонецПроцедуры

#КонецОбласти








