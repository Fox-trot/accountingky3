﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура формирования отчета.
//
// Параметры:
//  СтруктураПараметров	 - Структура - Параметры формирования отчета.
//  	* МассивСсылок - Массив - Массив ссылок на документы
//  	* АдресХранилищаПрогресса - Строка- Адрес временного хранилища
//  АдресХранилища		 - Строка	 - Адрес временного хранилища.
//
Процедура ПерепровестиДокументы(СтруктураПараметров, АдресХранилища) Экспорт
	
	РезультатФормирования = Новый Структура("Результат, ОписаниеОшибки", Неопределено, "");
	СформироватьТабличныйДокумент(СтруктураПараметров, РезультатФормирования);
	ПоместитьВоВременноеХранилище(РезультатФормирования, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура - Сформировать табличный документ
//
// Параметры:
//  СтруктураПараметров	 - Структура - Параметры формирования отчета.
//  РезультатФормирования	 	- Структура - 
//
Процедура СформироватьТабличныйДокумент(СтруктураПараметров, РезультатФормирования)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "МониторОС_ОсновнойМакет";
		
	Макет = ПолучитьМакет("Макет");
	ОбластьСтрока 	= Макет.ПолучитьОбласть("ОбластьСтрока");
	МассивСсылок = СтруктураПараметров.МассивСсылок;
	КоличествоДокументов = МассивСсылок.Количество();
	Если КоличествоДокументов > 0 Тогда
		Прирост = 100 / КоличествоДокументов;
		Сч = 0;
		АдресХранилищаПрогресса = СтруктураПараметров.АдресХранилищаПрогресса;
		Для каждого СсылкаДокумента Из МассивСсылок Цикл
			СсылкаДокумента.ПолучитьОбъект().Записать(РежимЗаписиДокумента.Проведение);
			ОбластьСтрока.Параметры.СтрокаРезультат = "Перепроведен:" + Строка(СсылкаДокумента);
			ТабличныйДокумент.Вывести(ОбластьСтрока);
			Сч = Сч + Прирост;
			ПоместитьВоВременноеХранилище(Сч, АдресХранилищаПрогресса);		
		КонецЦикла;
	КонецЕсли;
		
	РезультатФормирования.Результат = ТабличныйДокумент;
КонецПроцедуры

#КонецОбласти

#КонецЕсли