﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПредставлениеУченойСтепениФизическогоЛица(ФизическоеЛицоСсылка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	УченыеСтепениФизическихЛиц.Физлицо КАК ФизическоеЛицо1,
		|	УченыеСтепениФизическихЛиц.НомерПоПорядку,
		|	УченыеСтепениФизическихЛиц.УченаяСтепень,
		|	УченыеСтепениФизическихЛиц.ДатаПрисужденияУченойСтепени,
		|	УченыеСтепениФизическихЛиц.ОтрасльНауки,
		|	УченыеСтепениФизическихЛиц.ДиссертационныйСовет,
		|	УченыеСтепениФизическихЛиц.ДипломСерияНомер,
		|	УченыеСтепениФизическихЛиц.ДипломВыданОрганизация
		|ИЗ
		|	РегистрСведений.УченыеСтепениФизическихЛиц КАК УченыеСтепениФизическихЛиц
		|ГДЕ
		|	УченыеСтепениФизическихЛиц.Физлицо = &ФизическоеЛицоСсылка";
		
	Запрос.УстановитьПараметр("ФизическоеЛицоСсылка", ФизическоеЛицоСсылка);
	
	Возврат ПредставлениеУченойСтепениПоКоллекцииЗаписей(Запрос.Выполнить().Выгрузить());
	
КонецФункции

Функция ПредставлениеУченойСтепениПоКоллекцииЗаписей(НаборЗаписей) Экспорт
	
	ПредставлениеУченыеСтепени = "";
	
	ПоследняяУченаяСтепень = Неопределено;
	Для Каждого СтрокаУченыеСтепени Из НаборЗаписей Цикл
		Если ПоследняяУченаяСтепень = Неопределено ИЛИ ПоследняяУченаяСтепень.ДатаПрисужденияУченойСтепени < СтрокаУченыеСтепени.ДатаПрисужденияУченойСтепени Тогда
			ПоследняяУченаяСтепень = СтрокаУченыеСтепени;
		КонецЕсли; 
	КонецЦикла;
	
	Если ПоследняяУченаяСтепень <> Неопределено Тогда
		ПредставлениеУченыеСтепени = ?(ЗначениеЗаполнено(ПоследняяУченаяСтепень.УченаяСтепень), Строка(ПоследняяУченаяСтепень.УченаяСтепень), "");
		ПредставлениеУченыеСтепени = ПредставлениеУченыеСтепени + ?(ЗначениеЗаполнено(ПоследняяУченаяСтепень.ОтрасльНауки), ?(ПустаяСтрока(ПредставлениеУченыеСтепени), "", ", ") + Строка(ПоследняяУченаяСтепень.ОтрасльНауки), "");
		ПредставлениеУченыеСтепени = ПредставлениеУченыеСтепени + ?(ЗначениеЗаполнено(ПоследняяУченаяСтепень.ДатаПрисужденияУченойСтепени), ?(ПустаяСтрока(ПредставлениеУченыеСтепени), "", ", ") + Формат(ПоследняяУченаяСтепень.ДатаПрисужденияУченойСтепени, "ДЛФ=D"), "");
		ПредставлениеУченыеСтепени = ПредставлениеУченыеСтепени + ?(ЗначениеЗаполнено(ПоследняяУченаяСтепень.ДиссертационныйСовет), ?(ПустаяСтрока(ПредставлениеУченыеСтепени), "", ", ") + Строка(ПоследняяУченаяСтепень.ДиссертационныйСовет), "");
	КонецЕсли;
	
	Если ПустаяСтрока(ПредставлениеУченыеСтепени) Тогда
		ПредставлениеУченыеСтепени = НСтр("ru = 'Ученые степени не присуждались'");
	КонецЕсли; 
	
	Возврат ПредставлениеУченыеСтепени;
	
КонецФункции

#КонецЕсли