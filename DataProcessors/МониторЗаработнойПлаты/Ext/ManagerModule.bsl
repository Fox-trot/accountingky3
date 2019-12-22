﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Процедура - Перепровести документы
//
// Параметры:
//  СтруктураПараметров	 - Структура - набор параметров, необходимых для построения отчета.
//		* МассивСсылок - Массив - Массив ссылок на документы
//		* АдресРасшифровки - Строка - Адрес во временном хранилище
//		* АдресХранилищаПрогресса - Строка - Адрес во временном хранилище
//  АдресХранилища		 - Строка	 - Адрес во временном хранилище 
//
Процедура ПерепровестиДокументы(СтруктураПараметров, АдресХранилища) Экспорт
	
	РезультатФормирования = Новый Структура("Результат, ОписаниеОшибки", Неопределено, "");
	СформироватьТабличныйДокумент(СтруктураПараметров, РезультатФормирования);
	ПоместитьВоВременноеХранилище(РезультатФормирования, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. ПерепровестиДокументы
//
Процедура СформироватьТабличныйДокумент(СтруктураПараметров, РезультатФормирования)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "МониторЗП_ОсновнойМакет";
		
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