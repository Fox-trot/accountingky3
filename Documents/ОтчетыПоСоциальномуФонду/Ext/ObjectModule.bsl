﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСоцфонд(ДанныеУчетнойПолитики) Экспорт
	
	Период = ?(ЗначениеЗаполнено(ДатаСдачиОтчета), КонецДня(ДатаСдачиОтчета), КонецМесяца(Дата) + 1);
	
	// Определение отбора по подразделениям.
	МассивПодразделений = Новый Массив;
	Если ДанныеУчетнойПолитики.ПределыПоПодразделениям Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПределыПоПодразделениямСрезПоследних.Подразделение КАК Подразделение
			|ИЗ
			|	РегистрСведений.ПределыПоПодразделениям.СрезПоследних(&Период, Организация = &Организация) КАК ПределыПоПодразделениямСрезПоследних
			|ГДЕ
			|	ПределыПоПодразделениямСрезПоследних.ОтделениеСФ = &ОтделениеСФ";
		Запрос.УстановитьПараметр("Период", Период);
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("ОтделениеСФ", Контрагент);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			МассивПодразделений.Добавить(ВыборкаДетальныеЗаписи.Подразделение);		
		КонецЦикла;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.Физлицо КАК ФизЛицо,
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.Физлицо.Наименование КАК ФизЛицоНаименование,
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.Категория КАК Категория,
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.ФОТОборот КАК ФондОплатыТруда,
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.ДопФОТОборот КАК ДополнительныйФондОплатыТруда,
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.НачисленыеВзносыОборот КАК НачисленыеСтраховыеВзносы,
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.ГНПФРОборот КАК НачсиленыеВзносыПоНПФ,
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.НормаДнейОборот КАК Дней,
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.ФактДнейОборот КАК ФактическиДней,
		|	ДанныеДляОтчетаПоСФЕжемесячномуОбороты.ПриведеннаяСЗПОборот КАК ПриведеннаяСЗПОборот
		|ПОМЕСТИТЬ ВременнаяТаблицаДанные
		|ИЗ
		|	РегистрНакопления.ДанныеДляОтчетаПоСФЕжемесячному.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			,
		|			Организация = &Организация
		|				И Подразделение В (&МассивПодразделений)) КАК ДанныеДляОтчетаПоСФЕжемесячномуОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		
		|ВЫБРАТЬ
		|	ВременнаяТаблицаДанные.ФизЛицо КАК ФизЛицо,
		|	ВременнаяТаблицаДанные.ФизЛицоНаименование КАК ФизЛицоНаименование,
		|	ВременнаяТаблицаДанные.Категория КАК Категория,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаДанные.ФондОплатыТруда КАК ЧИСЛО(15, 2)) КАК ФондОплатыТруда,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаДанные.ДополнительныйФондОплатыТруда КАК ЧИСЛО(15, 2)) КАК ДополнительныйФондОплатыТруда,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаДанные.НачисленыеСтраховыеВзносы КАК ЧИСЛО(15, 2)) КАК НачисленыеСтраховыеВзносы,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаДанные.НачсиленыеВзносыПоНПФ КАК ЧИСЛО(15, 2)) КАК НачсиленыеВзносыПоНПФ,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(СотрудникиПрием.Период, &НачалоПериода) < &НачалоПериода
		|			ТОГДА &НачалоПериода
		|		ИНАЧЕ ЕСТЬNULL(СотрудникиПрием.Период, &НачалоПериода)
		|	КОНЕЦ КАК ДатаНачалаРаботы,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(СотрудникиУвольнение.Период, &КонецПериода) > &НачалоПериода
		|			ТОГДА ЕСТЬNULL(СотрудникиУвольнение.Период, &КонецПериода)
		|		ИНАЧЕ &КонецПериода
		|	КОНЕЦ КАК ДатаОкончанияРаботы,
		|	ВременнаяТаблицаДанные.Дней КАК Дней,
		|	ВременнаяТаблицаДанные.ФактическиДней КАК ФактическиДней
		|ИЗ
		|	ВременнаяТаблицаДанные КАК ВременнаяТаблицаДанные
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники.СрезПоследних(
		|				&КонецПериода,
		|				ФизЛицо В
		|						(ВЫБРАТЬ
		|							ВременнаяТаблицаДанные.ФизЛицо КАК ФизЛицо
		|						ИЗ
		|							ВременнаяТаблицаДанные КАК ВременнаяТаблицаДанные)
		|					И Организация = &Организация
		|					И ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Прием)) КАК СотрудникиПрием
		|		ПО ВременнаяТаблицаДанные.ФизЛицо = СотрудникиПрием.ФизЛицо
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Сотрудники.СрезПоследних(
		|				&КонецПериода,
		|				ФизЛицо В
		|						(ВЫБРАТЬ
		|							ВременнаяТаблицаДанные.ФизЛицо КАК ФизЛицо
		|						ИЗ
		|							ВременнаяТаблицаДанные КАК ВременнаяТаблицаДанные)
		|					И Организация = &Организация
		|					И ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)) КАК СотрудникиУвольнение
		|		ПО ВременнаяТаблицаДанные.ФизЛицо = СотрудникиУвольнение.ФизЛицо
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВременнаяТаблицаДанные.ФизЛицоНаименование
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		
		|ВЫБРАТЬ
		|	ВременнаяТаблицаДанные.Категория КАК Категория,
		|	СУММА(ВЫБОР
		|			КОГДА ВременнаяТаблицаДанные.ПриведеннаяСЗПОборот > ВременнаяТаблицаДанные.ФондОплатыТруда
		|				ТОГДА ВЫРАЗИТЬ(ВременнаяТаблицаДанные.ФондОплатыТруда КАК ЧИСЛО(15, 2))
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ФОТМенее,
		|	СУММА(ВременнаяТаблицаДанные.ДополнительныйФондОплатыТруда) КАК ДопФОТ,
		|	СУММА(ВЫБОР
		|			КОГДА ВременнаяТаблицаДанные.ПриведеннаяСЗПОборот <= ВременнаяТаблицаДанные.ФондОплатыТруда
		|				ТОГДА ВЫРАЗИТЬ(ВременнаяТаблицаДанные.ФондОплатыТруда КАК ЧИСЛО(15, 2))
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ФОТБолее,
		|	СУММА(ВЫРАЗИТЬ(ВременнаяТаблицаДанные.ФондОплатыТруда + ВременнаяТаблицаДанные.ДополнительныйФондОплатыТруда КАК ЧИСЛО(15, 2))) КАК Итого,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВременнаяТаблицаДанные.ФизЛицо) КАК Численость
		|ИЗ
		|	ВременнаяТаблицаДанные КАК ВременнаяТаблицаДанные
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаДанные.Категория
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		
		|ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ЕСТЬNULL(ХозрасчетныйОстатки.СуммаОстаток, 0) КАК ЧИСЛО(15, 2)) КАК ОстатокСтраховыхВзносов
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(&Дата, Счет В (&СписокСчетов), , Организация = &Организация) КАК ХозрасчетныйОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ЕСТЬNULL(ХозрасчетныйОстатки.СуммаОстаток, 0) КАК ЧИСЛО(15, 2)) КАК ОстатокПенсионногоФонда
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(&Дата, Счет = &Счет, , Организация = &Организация) КАК ХозрасчетныйОстатки";
	Если Округление Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ЧИСЛО(15, 2)", "ЧИСЛО(15, 0)");
	КонецЕсли;
	
	Если ДанныеУчетнойПолитики.ПределыПоПодразделениям Тогда
		Запрос.УстановитьПараметр("МассивПодразделений", МассивПодразделений);
	Иначе 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Подразделение В (&МассивПодразделений)", "ИСТИНА");
	КонецЕсли;	
	
	ДанныеУчетнойПолитики = БухгалтерскийУчетСервер.ПолучитьДанныеУчетнойПолитикиПоПерсоналу(Дата, Организация);
	МассивСчетов = Новый Массив();
	МассивСчетов.Добавить(ДанныеУчетнойПолитики.СчетУчетаРасчетовПФФ);
	МассивСчетов.Добавить(ДанныеУчетнойПолитики.СчетУчетаРасчетовМСФ);
	МассивСчетов.Добавить(ДанныеУчетнойПолитики.СчетУчетаРасчетовФОТФ);
	СчетГНПФР = ДанныеУчетнойПолитики.СчетУчетаРасчетовГНПФР;
	
	Запрос.УстановитьПараметр("Дата", Период);
	Запрос.УстановитьПараметр("СписокСчетов", МассивСчетов);
	Запрос.УстановитьПараметр("Счет", СчетГНПФР);
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Дата));            
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	СведенияОЗанятостиИЗаработнойПлате.Загрузить(РезультатЗапроса[1].Выгрузить());
	ФондОплатыТрудаПоКатегориям.Загрузить(РезультатЗапроса[2].Выгрузить());
	
	ОбязательстваПоСтраховымВзносам = 0;
	ОбязательстваПоПенсионномуФонду = 0;
	ПереплатаПоСтраховымВзносам 	= 0;
	ПереплатаПоПенсионномуФонду	 	= 0;
	
	СтраховыеВзносы = РезультатЗапроса[3].Выгрузить()[0].ОстатокСтраховыхВзносов;
	Если СтраховыеВзносы > 0 Тогда
		ПереплатаПоСтраховымВзносам = СтраховыеВзносы;
	ИначеЕсли СтраховыеВзносы < 0 Тогда
		ОбязательстваПоСтраховымВзносам = - СтраховыеВзносы;
	КонецЕсли;
	
	ПенсионныйФонд = РезультатЗапроса[4].Выгрузить()[0].ОстатокПенсионногоФонда;
	Если ПенсионныйФонд > 0 Тогда
		ПереплатаПоПенсионномуФонду = ПенсионныйФонд;
	ИначеЕсли ПенсионныйФонд < 0 Тогда
		ОбязательстваПоПенсионномуФонду = - ПенсионныйФонд;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли