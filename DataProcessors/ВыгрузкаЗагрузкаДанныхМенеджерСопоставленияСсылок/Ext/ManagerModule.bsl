﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ВыполнитьСтандартноеСопоставлениеСсылок(ПотокЗаменыСсылок, Знач ОбъектМетаданных, Знач ТаблицаИсходныхСсылок, Знач МенеджерСопоставленияСсылок) Экспорт
	
	ИмяТипаXML = ВыгрузкаЗагрузкаДанныхСлужебный.XMLТипСсылки(ОбъектМетаданных);
	
	ИмяКолонкиИсходнойСсылки = МенеджерСопоставленияСсылок.ИмяКолонкиИсходныхСсылок();
	
	Выборка = ВыборкаСопоставленияСсылок(ОбъектМетаданных, ТаблицаИсходныхСсылок, ИмяКолонкиИсходнойСсылки);
	
	Пока Выборка.Следующий() Цикл
		
		ПотокЗаменыСсылок.ЗаменитьСсылку(ИмяТипаXML, Строка(Выборка[ИмяКолонкиИсходнойСсылки].УникальныйИдентификатор()),
			Строка(Выборка.Ссылка.УникальныйИдентификатор()));
		
	КонецЦикла;
	
КонецПроцедуры

Функция ВыборкаСопоставленияСсылок(Знач ОбъектМетаданных, Знач ТаблицаИсходныхСсылок, Знач ИмяКолонкиИсходнойСсылки) Экспорт
	
	ПоляКлюча = Новый Массив();
	Для Каждого КолонкаКлюча Из ТаблицаИсходныхСсылок.Колонки Цикл
		Если КолонкаКлюча.Имя <> ИмяКолонкиИсходнойСсылки Тогда
			ПоляКлюча.Добавить(КолонкаКлюча.Имя);
		КонецЕсли;
	КонецЦикла;
	
	ТекстЗапросаСопоставления = СформироватьТекстЗапросаСопоставленияСсылокПоЕстественнымКлючам(
		ОбъектМетаданных, ТаблицаИсходныхСсылок.Колонки, ИмяКолонкиИсходнойСсылки);
	
	Запрос = Новый Запрос(ТекстЗапросаСопоставления);
	Запрос.УстановитьПараметр("ТаблицаИсходныхСсылок", ТаблицаИсходныхСсылок);
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирование запроса для получения ссылок неразделенных данных в ИБ
//
// Возвращаемое значение:
//  Строка
//
Функция СформироватьТекстЗапросаСопоставленияСсылокПоЕстественнымКлючам(Знач ОбъектМетаданных, Знач Колонки, Знач ИмяКолонкиИсходнойСсылки)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаИсходныхСсылок.*
	|ПОМЕСТИТЬ ИсходныеСсылки
	|ИЗ
	|	&ТаблицаИсходныхСсылок КАК ТаблицаИсходныхСсылок;
	|ВЫБРАТЬ
	|	ИсходныеСсылки.%ИсходнаяСсылка КАК %ИсходнаяСсылка,
	|	_XMLЗагрузка_Таблица.Ссылка КАК Ссылка
	|ИЗ
	|	ИсходныеСсылки КАК ИсходныеСсылки
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ " + ОбъектМетаданных.ПолноеИмя() + " КАК _XMLЗагрузка_Таблица ";
	
	Итерация = 1;
	Для Каждого Колонка Из Колонки Цикл 
		
		Если Колонка.Имя = ИмяКолонкиИсходнойСсылки Тогда 
			Продолжить;
		КонецЕсли;
		
		ТекстЗапроса = ТекстЗапроса + "%ЛогическаяФункция (ИсходныеСсылки.%ИмяКлюча = _XMLЗагрузка_Таблица.%ИмяКлюча) ";
		
		ЛогическаяФункция = ?(Итерация = 1, "ПО", "И");
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ИмяКлюча",          Колонка.Имя);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ЛогическаяФункция", ЛогическаяФункция);
		
		Итерация = Итерация + 1;
		
	КонецЦикла;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ИсходнаяСсылка", ИмяКолонкиИсходнойСсылки);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецЕсли