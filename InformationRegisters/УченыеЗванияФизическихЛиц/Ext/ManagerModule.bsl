﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПредставлениеУченогоЗванияФизическогоЛица(ФизическоеЛицоСсылка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	УченыеЗванияФизическихЛиц.ФизЛицо КАК ФизическоеЛицо1,
		|	УченыеЗванияФизическихЛиц.НомерПоПорядку,
		|	УченыеЗванияФизическихЛиц.УченоеЗвание,
		|	УченыеЗванияФизическихЛиц.ДатаПрисвоенияУченогоЗвания,
		|	УченыеЗванияФизическихЛиц.АттестатСерия,
		|	УченыеЗванияФизическихЛиц.АттестатНомер,
		|	УченыеЗванияФизическихЛиц.АттестатВыданОрганизация,
		|	УченыеЗванияФизическихЛиц.НаучнаяСпециальность
		|ИЗ
		|	РегистрСведений.УченыеЗванияФизическихЛиц КАК УченыеЗванияФизическихЛиц
		|ГДЕ
		|	УченыеЗванияФизическихЛиц.ФизЛицо = &ФизическоеЛицоСсылка";
		
	Запрос.УстановитьПараметр("ФизическоеЛицоСсылка", ФизическоеЛицоСсылка);
	
	Возврат ПредставлениеУченогоЗванияПоКоллекцииЗаписей(Запрос.Выполнить().Выгрузить());
	
КонецФункции

Функция ПредставлениеУченогоЗванияПоКоллекцииЗаписей(НаборЗаписей) Экспорт
	
	ПредставлениеУченыеЗвания = "";
	
	ПоследнееУченоеЗвание = Неопределено;
	Для Каждого СтрокаУченыеЗвания Из НаборЗаписей Цикл
		Если ПоследнееУченоеЗвание = Неопределено ИЛИ ПоследнееУченоеЗвание.ДатаПрисвоенияУченогоЗвания < СтрокаУченыеЗвания.ДатаПрисвоенияУченогоЗвания Тогда
			ПоследнееУченоеЗвание = СтрокаУченыеЗвания;
		КонецЕсли; 
	КонецЦикла;
	
	Если ПоследнееУченоеЗвание <> Неопределено Тогда
		ПредставлениеУченыеЗвания 	= ?(ЗначениеЗаполнено(ПоследнееУченоеЗвание.УченоеЗвание), Строка(ПоследнееУченоеЗвание.УченоеЗвание), "");
		ПредставлениеУченыеЗвания = ПредставлениеУченыеЗвания + ?(ЗначениеЗаполнено(ПоследнееУченоеЗвание.НаучнаяСпециальность), ?(ПустаяСтрока(ПредставлениеУченыеЗвания), "", ", ") + Строка(ПоследнееУченоеЗвание.НаучнаяСпециальность), "");
		ПредставлениеУченыеЗвания = ПредставлениеУченыеЗвания + ?(ЗначениеЗаполнено(ПоследнееУченоеЗвание.ДатаПрисвоенияУченогоЗвания), ?(ПустаяСтрока(ПредставлениеУченыеЗвания), "", ", ") + Формат(ПоследнееУченоеЗвание.ДатаПрисвоенияУченогоЗвания, "ДЛФ=D"), "");
	КонецЕсли;
	
	Если ПустаяСтрока(ПредставлениеУченыеЗвания) Тогда
		ПредставлениеУченыеЗвания = НСтр("ru = 'Ученые звания не присваивались'");
	КонецЕсли; 
	
	Возврат ПредставлениеУченыеЗвания;
	
КонецФункции

#КонецОбласти

#КонецЕсли