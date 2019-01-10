﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет дополнить регистры с движениями документа дополнительными регистрами.
//
// Параметры:
//    Документ - ДокументСсылка - документ коллекцию движений которого необходимо дополнить.
//    РегистрыСДвижениями - Соответствие - соответствие с данными:
//        * Ключ     - ОбъектМетаданных - регистр как объект метаданных.
//        * Значение - Строка           - имя поля регистратора.
//
Процедура ПриОпределенииРегистровСДвижениями(Документ, РегистрыСДвижениями) Экспорт
	
	
	
КонецПроцедуры

// Позволяет рассчитать количество записей для дополнительных наборов, добавленных процедурой
// ПриОпределенииРегистровСДвижениями.
//
// Параметры:
//    Документ - ДокументСсылка - документ коллекцию движений которого необходимо дополнить.
//    РассчитанноеКоличество - Соответствие - соответствие с данными:
//        * Ключ     - Строка - полное имя регистра (вместо точек используется символ подчеркивания).
//        * Значение - Число  - рассчитанное количество записей.
//
Процедура ПриРасчетеКоличестваЗаписей(Документ, РассчитанноеКоличество) Экспорт
	
	
	
КонецПроцедуры

// Позволяет дополнить или переопределить коллекцию наборов данных для вывода движений документа.
//
// Параметры:
//    Документ - ДокументСсылка - документ, коллекцию движений которого необходимо дополнить.
//    НаборыДанных - Массив - сведения о наборах данных (тип элемента Структура).
//
Процедура ПриПодготовкеНабораДанных(Документ, НаборыДанных) Экспорт
	
	// Переопределение сортировки вывода
	// Самым верхним выводится РБ Хозрасчетный
	// Затем все остальные
	
	// Массив, содержащий все данные НаборыДанных заисключением РБ Хозрасчетный.
	НаборыДанныхПереопределяемый = Новый Массив;
	// Переменная для данных по РБ Хозрасчетный.
	СтруктураХозрасчетный = Неопределено;
	
	Для Каждого ЭлементМассива Из НаборыДанных Цикл 
		Если ЭлементМассива.ИмяРегистра = "Хозрасчетный" Тогда 
			СтруктураХозрасчетный = ЭлементМассива;
		Иначе 
			НаборыДанныхПереопределяемый.Добавить(ЭлементМассива);	
		КонецЕсли;
	КонецЦикла;	
	
	// Необходимость переопределения.
	Если НЕ СтруктураХозрасчетный = Неопределено Тогда 
		НаборыДанных.Очистить();
		НаборыДанных.Добавить(СтруктураХозрасчетный);
		// Дополнение массива. 
		Для Каждого ЭлементМассива Из НаборыДанныхПереопределяемый Цикл 
			НаборыДанных.Добавить(ЭлементМассива);
		КонецЦикла;	
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти
