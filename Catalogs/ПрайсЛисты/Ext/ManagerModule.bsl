﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции
	
Процедура СоздатьНовуюТаблицуРеквизитов(ДоступныеПоля)
	
	ДоступныеПоля = Новый ТаблицаЗначений;
	ДоступныеПоля.Колонки.Добавить("Использование");
	ДоступныеПоля.Колонки.Добавить("РеквизитНоменклатуры");
	ДоступныеПоля.Колонки.Добавить("РеквизитПредставление");
	ДоступныеПоля.Колонки.Добавить("ПараметрРасшифровки");
	ДоступныеПоля.Колонки.Добавить("Ширина");
	ДоступныеПоля.Колонки.Добавить("СлужебныйУправлениеВидимостью");
	
КонецПроцедуры

Процедура ДобавитьСтрокуВТаблицуРеквизитов(ДоступныеПоля, Использование, РеквизитНоменклатуры, РеквизитПредставление, Ширина, ПараметрРасшифровки = "", СлужебныйУправлениеВидимостью = Истина)
	
	НоваяСтрока									= ДоступныеПоля.Добавить();
	НоваяСтрока.Использование					= Использование;
	НоваяСтрока.РеквизитНоменклатуры			= РеквизитНоменклатуры;
	НоваяСтрока.РеквизитПредставление			= РеквизитПредставление;
	НоваяСтрока.Ширина							= Ширина;
	НоваяСтрока.ПараметрРасшифровки				= ПараметрРасшифровки;
	НоваяСтрока.СлужебныйУправлениеВидимостью 	= СлужебныйУправлениеВидимостью;
	
КонецПроцедуры

Процедура ДоступныеПоляНоменклатуры(ДоступныеПоля) Экспорт
	
	СоздатьНовуюТаблицуРеквизитов(ДоступныеПоля);
	
	ДобавитьСтрокуВТаблицуРеквизитов(ДоступныеПоля, Истина, "Картинка",				НСтр("ru = 'Картинка'"),			8,  "НоменклатураСсылка");
	ДобавитьСтрокуВТаблицуРеквизитов(ДоступныеПоля, Истина, "Код",					НСтр("ru = 'Код'"),					11, "НоменклатураСсылка");
	ДобавитьСтрокуВТаблицуРеквизитов(ДоступныеПоля, Истина, "Наименование",			НСтр("ru = 'Наименование'"),		30, "НоменклатураСсылка");
	ДобавитьСтрокуВТаблицуРеквизитов(ДоступныеПоля, Истина, "НаименованиеПолное",	НСтр("ru = 'Полное наименование'"),	30, "НоменклатураСсылка");
	ДобавитьСтрокуВТаблицуРеквизитов(ДоступныеПоля, Истина, "Комментарий",			НСтр("ru = 'Описание'"),			30, "НоменклатураСсылка");
	ДобавитьСтрокуВТаблицуРеквизитов(ДоступныеПоля, Ложь,	"СвободныйОстаток",		НСтр("ru = 'Свободный остаток'"),	10, "НоменклатураСсылка");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли