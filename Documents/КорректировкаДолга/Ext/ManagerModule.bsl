﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает курс аванса, рассчитанный как частное от деления
// рублевого остатка по договору на валютный.
//
Функция ПолучитьКурсВалютыАванса(Договор, Организация, ДатаКурса, КурсДокумента = 1) Экспорт
	
	ПорядокСубконто = Новый Массив;
	ПорядокСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ПорядокСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаКурса", ДатаКурса);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("Контрагент", Договор.Владелец);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ПорядокСубконто", ПорядокСубконто);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Хозрасчетный.Ссылка КАК Счет
		|ПОМЕСТИТЬ ВТ_СчетаУчетаРасчетов
		|ИЗ
		|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
		|ГДЕ
		|	Хозрасчетный.Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.АвансыПолученные), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.АвансыВыданные), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.СчетаКПолучению), ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.СчетаКОплате))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ХозрасчетныйОстатки.СуммаОстаток КАК СуммаОстаток,
		|	ХозрасчетныйОстатки.ВалютнаяСуммаОстаток КАК ВалютнаяСуммаОстаток
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&ДатаКурса,
		|			Счет В
		|				(ВЫБРАТЬ
		|					ВТ_СчетаУчетаРасчетов.Счет
		|				ИЗ
		|					ВТ_СчетаУчетаРасчетов),
		|			&ПорядокСубконто,
		|			Субконто1 = &Контрагент
		|				И Субконто2 = &Договор
		|				И Организация = &Организация) КАК ХозрасчетныйОстатки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат КурсДокумента;
		
	Иначе
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		Возврат ?(Выборка.ВалютнаяСуммаОстаток = 0, КурсДокумента, Окр(Выборка.СуммаОстаток / Выборка.ВалютнаяСуммаОстаток, 4));
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти
	
#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру бухгалтерии Хозрасчетный.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаДебиторскаяЗадолженность.СчетУчетаРасчетов КАК СчетДт,
		|	ВременнаяТаблицаДебиторскаяЗадолженность.КорСчетУчетаРасчетов КАК СчетКт,
		|	ВременнаяТаблицаШапка.КонтрагентКредитор КАК СубконтоДт1,
		|	ВременнаяТаблицаДебиторскаяЗадолженность.КорДоговорКонтрагента КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.КонтрагентДебитор КАК СубконтоКт1,
		|	ВременнаяТаблицаДебиторскаяЗадолженность.ДоговорКонтрагента КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаДебиторскаяЗадолженность.ВалютаРасчетовКонтрагент = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаДебиторскаяЗадолженность.Сумма
		|		КОГДА ВременнаяТаблицаДебиторскаяЗадолженность.ВалютаРасчетовКорКонтрагент = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаДебиторскаяЗадолженность.Сумма * ВременнаяТаблицаДебиторскаяЗадолженность.КурсВзаиморасчетов / ВременнаяТаблицаДебиторскаяЗадолженность.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаДебиторскаяЗадолженность.Сумма * ВременнаяТаблицаШапка.КурсДокумента / ВременнаяТаблицаШапка.КратностьДокумента
		|	КОНЕЦ КАК Сумма,
		|	ВременнаяТаблицаДебиторскаяЗадолженность.ВалютаРасчетовКорКонтрагент КАК ВалютаДт,
		|	ВременнаяТаблицаДебиторскаяЗадолженность.ВалютаРасчетовКонтрагент КАК ВалютаКт,
		|	ВременнаяТаблицаДебиторскаяЗадолженность.Сумма КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаДебиторскаяЗадолженность.Сумма КАК ВалютнаяСуммаКт,
		|	""Перенос задолженности"" КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаДебиторскаяЗадолженность КАК ВременнаяТаблицаДебиторскаяЗадолженность
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО Истина Где ВременнаяТаблицаШапка.ВидОперации = Значение(Перечисление.ВидыОперацийКорректировкаДолга.ПереносЗадолженности)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаКредиторскаяЗадолженность.СчетУчетаРасчетов,
		|	ВременнаяТаблицаКредиторскаяЗадолженность.КорСчетУчетаРасчетов,
		|	ВременнаяТаблицаШапка.КонтрагентКредитор,
		|	ВременнаяТаблицаКредиторскаяЗадолженность.КорДоговорКонтрагента,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаШапка.КонтрагентДебитор,
		|	ВременнаяТаблицаКредиторскаяЗадолженность.ДоговорКонтрагента,
		|	НЕОПРЕДЕЛЕНО,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаКредиторскаяЗадолженность.ВалютаРасчетовКонтрагент = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаКредиторскаяЗадолженность.Сумма
		|		КОГДА ВременнаяТаблицаКредиторскаяЗадолженность.ВалютаРасчетовКорКонтрагент = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаКредиторскаяЗадолженность.Сумма * ВременнаяТаблицаКредиторскаяЗадолженность.КурсВзаиморасчетов / ВременнаяТаблицаКредиторскаяЗадолженность.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаКредиторскаяЗадолженность.Сумма * ВременнаяТаблицаШапка.КурсДокумента / ВременнаяТаблицаШапка.КратностьДокумента
		|	КОНЕЦ,
		|	ВременнаяТаблицаКредиторскаяЗадолженность.ВалютаРасчетовКонтрагент,
		|	ВременнаяТаблицаКредиторскаяЗадолженность.ВалютаРасчетовКорКонтрагент,
		|	ВременнаяТаблицаКредиторскаяЗадолженность.Сумма,
		|	ВременнаяТаблицаКредиторскаяЗадолженность.Сумма,
		|	""Перенос задолженности""
		|ИЗ
		|	ВременнаяТаблицаКредиторскаяЗадолженность КАК ВременнаяТаблицаКредиторскаяЗадолженность
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО Истина Где ВременнаяТаблицаШапка.ВидОперации = Значение(Перечисление.ВидыОперацийКорректировкаДолга.ПереносЗадолженности)";
	
	ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|";
	
	ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.СчетДт КАК СчетДт,
		|	ВременнаяТаблицаДебиторскаяЗадолженность.СчетУчетаРасчетов КАК СчетКт,
		|	ВременнаяТаблицаШапка.СубконтоДт1 КАК СубконтоДт1,
		|	ВременнаяТаблицаШапка.СубконтоДт2 КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.КонтрагентДебитор КАК СубконтоКт1,
		|	ВременнаяТаблицаДебиторскаяЗадолженность.ДоговорКонтрагента КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаДебиторскаяЗадолженность.ВалютаРасчетовКонтрагент = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаДебиторскаяЗадолженность.Сумма
		|		КОГДА ВременнаяТаблицаДебиторскаяЗадолженность.ВалютаРасчетовКорКонтрагент = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаДебиторскаяЗадолженность.Сумма * ВременнаяТаблицаДебиторскаяЗадолженность.КурсВзаиморасчетов / ВременнаяТаблицаДебиторскаяЗадолженность.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаДебиторскаяЗадолженность.Сумма * ВременнаяТаблицаШапка.КурсДокумента / ВременнаяТаблицаШапка.КратностьДокумента
		|	КОНЕЦ КАК Сумма,
		|	ВременнаяТаблицаШапка.СубконтоДт2.ВалютаРасчетов КАК ВалютаДт,
		|	ВременнаяТаблицаДебиторскаяЗадолженность.ВалютаРасчетовКонтрагент КАК ВалютаКт,
		|	ВременнаяТаблицаДебиторскаяЗадолженность.Сумма КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаДебиторскаяЗадолженность.Сумма КАК ВалютнаяСуммаКт,
		|	""Списание задолженности"" КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаДебиторскаяЗадолженность КАК ВременнаяТаблицаДебиторскаяЗадолженность
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО Истина Где ВременнаяТаблицаШапка.ВидОперации = Значение(Перечисление.ВидыОперацийКорректировкаДолга.СписаниеЗадолженности)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаКредиторскаяЗадолженность.СчетУчетаРасчетов,
		|	ВременнаяТаблицаШапка.СчетКт,
		|	ВременнаяТаблицаШапка.КонтрагентКредитор,
		|	ВременнаяТаблицаКредиторскаяЗадолженность.ДоговорКонтрагента,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаШапка.СубконтоКт1,
		|	ВременнаяТаблицаШапка.СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаКредиторскаяЗадолженность.ВалютаРасчетовКонтрагент = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаКредиторскаяЗадолженность.Сумма
		|		КОГДА ВременнаяТаблицаКредиторскаяЗадолженность.ВалютаРасчетовКорКонтрагент = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаКредиторскаяЗадолженность.Сумма * ВременнаяТаблицаКредиторскаяЗадолженность.КурсВзаиморасчетов / ВременнаяТаблицаКредиторскаяЗадолженность.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаКредиторскаяЗадолженность.Сумма * ВременнаяТаблицаШапка.КурсДокумента / ВременнаяТаблицаШапка.КратностьДокумента
		|	КОНЕЦ,
		|	ВременнаяТаблицаКредиторскаяЗадолженность.ВалютаРасчетовКонтрагент,
		|	ВременнаяТаблицаШапка.СубконтоКт2.ВалютаРасчетов,
		|	ВременнаяТаблицаКредиторскаяЗадолженность.Сумма,
		|	ВременнаяТаблицаКредиторскаяЗадолженность.Сумма,
		|	""Списание задолженности""
		|ИЗ
		|	ВременнаяТаблицаКредиторскаяЗадолженность КАК ВременнаяТаблицаКредиторскаяЗадолженность
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО Истина Где ВременнаяТаблицаШапка.ВидОперации = Значение(Перечисление.ВидыОперацийКорректировкаДолга.СписаниеЗадолженности)";
	
	Запрос.Текст = ТекстЗапроса;
	РезультатЗапроса = Запрос.Выполнить();		
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаХозрасчетный", РезультатЗапроса.Выгрузить());
	
	
КонецПроцедуры // СформироватьТаблицаДенежныеСредства()

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Дата КАК Дата,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.ВидОперации КАК ВидОперации,
		|	ТаблицаДокумента.ВидАвансаЗадолженности КАК ВидАвансаЗадолженности,
		|	ТаблицаДокумента.ТипАвансаЗадолженности КАК ТипАвансаЗадолженности,
		|	ТаблицаДокумента.ВалютаДокумента КАК ВалютаДокумента,
		|	ТаблицаДокумента.КурсДокумента КАК КурсДокумента,
		|	ТаблицаДокумента.КратностьДокумента КАК КратностьДокумента,
		|	ТаблицаДокумента.КонтрагентДебитор КАК КонтрагентДебитор,
		|	ТаблицаДокумента.КонтрагентКредитор КАК КонтрагентКредитор,
		|	ТаблицаДокумента.ИспользоватьВспомогательныйСчет КАК ИспользоватьВспомогательныйСчет,
		|	&ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,
		|	ТаблицаДокумента.СчетДт КАК СчетДт,
		|	ТаблицаДокумента.СубконтоДт1 КАК СубконтоДт1,
		|	ТаблицаДокумента.СубконтоДт2 КАК СубконтоДт2,
		|	ТаблицаДокумента.СчетКт КАК СчетКт,
		|	ТаблицаДокумента.СубконтоКт1 КАК СубконтоКт1,
		|	ТаблицаДокумента.СубконтоКт2 КАК СубконтоКт2
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.КорректировкаДолга КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ТаблицаДокумента.КурсВзаиморасчетов КАК КурсВзаиморасчетов,
		|	ТаблицаДокумента.КратностьВзаиморасчетов КАК КратностьВзаиморасчетов,
		|	ТаблицаДокумента.Сумма КАК Сумма,
		|	ТаблицаДокумента.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
		|	ТаблицаДокумента.СчетУчетаРасчетов КАК СчетУчетаРасчетов,
		|	ТаблицаДокумента.КорДоговорКонтрагента КАК КорДоговорКонтрагента,
		|	ТаблицаДокумента.КорСчетУчетаРасчетов КАК КорСчетУчетаРасчетов,
		|	ТаблицаДокумента.ДоговорКонтрагента.ВалютаРасчетов КАК ВалютаРасчетовКонтрагент,
		|	ТаблицаДокумента.КорДоговорКонтрагента.ВалютаРасчетов КАК ВалютаРасчетовКорКонтрагент
		|ПОМЕСТИТЬ ВременнаяТаблицаДебиторскаяЗадолженность
		|ИЗ
		|	Документ.КорректировкаДолга.ДебиторскаяЗадолженность КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ТаблицаДокумента.КурсВзаиморасчетов КАК КурсВзаиморасчетов,
		|	ТаблицаДокумента.КратностьВзаиморасчетов КАК КратностьВзаиморасчетов,
		|	ТаблицаДокумента.Сумма КАК Сумма,
		|	ТаблицаДокумента.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
		|	ТаблицаДокумента.СчетУчетаРасчетов КАК СчетУчетаРасчетов,
		|	ТаблицаДокумента.КорДоговорКонтрагента КАК КорДоговорКонтрагента,
		|	ТаблицаДокумента.КорСчетУчетаРасчетов КАК КорСчетУчетаРасчетов,
		|	ТаблицаДокумента.ДоговорКонтрагента.ВалютаРасчетов КАК ВалютаРасчетовКонтрагент,
		|	ТаблицаДокумента.КорДоговорКонтрагента.ВалютаРасчетов КАК ВалютаРасчетовКорКонтрагент
		|ПОМЕСТИТЬ ВременнаяТаблицаКредиторскаяЗадолженность
		|ИЗ
		|	Документ.КорректировкаДолга.КредиторскаяЗадолженность КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КурсыВалютСрезПоследних.Валюта КАК Валюта,
		|	КурсыВалютСрезПоследних.Курс КАК Курс,
		|	КурсыВалютСрезПоследних.Кратность КАК Кратность
		|ПОМЕСТИТЬ ВременнаяТаблицаКурсыВалют
		|ИЗ
		|	РегистрСведений.КурсыВалют.СрезПоследних(&Период, Валюта В (&МассивВалют)) КАК КурсыВалютСрезПоследних";				
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);	
	Запрос.УстановитьПараметр("Период", СтруктураДополнительныеСвойства.ДляПроведения.Дата);	
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРегламентированногоУчета);	
	
	МассивВалют = Новый Массив();
	МассивВалют.Добавить(СтруктураДополнительныеСвойства.ДляПроведения.ВалютаДокумента);	
	МассивВалют.Добавить(СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРасчетов);
	Запрос.УстановитьПараметр("МассивВалют", МассивВалют);
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства);
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#КонецОбласти

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ИнтерфейсПечати

// Функция формирует табличный документ с печатной формой Платежное поручение
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьАктаВзаимозачета(МассивОбъектов, ОбъектыПечати)

	УстановитьПривилегированныйРежим(Истина);
	
	ВалютаРеглУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.РазмерКолонтитулаСверху	= 0;
	ТабличныйДокумент.РазмерКолонтитулаСнизу	= 0;
	ТабличныйДокумент.АвтоМасштаб				= Истина;
	ТабличныйДокумент.ОриентацияСтраницы		= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.КлючПараметровПечати		= "ПАРАМЕТРЫ_ПЕЧАТИ_КорректировкаДолга_Акт";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.КорректировкаДолга.ПФ_MXL_Взаимозачет");

	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КорректировкаДолга.Ссылка,
		|	КорректировкаДолга.Номер,
		|	КорректировкаДолга.Дата КАК Дата,
		|	КорректировкаДолга.КонтрагентДебитор КАК Дебитор,
		|	КорректировкаДолга.КонтрагентКредитор КАК Кредитор,
		|	КорректировкаДолга.Организация,
		|	КорректировкаДолга.ВалютаДокумента,
		|	КорректировкаДолга.ДебиторскаяЗадолженность.(
		|		ДоговорКонтрагента,
		|		ДоговорКонтрагента.Наименование КАК ДоговорПредставление,
		|		Сумма,
		|		СуммаВзаиморасчетов
		|	),
		|	КорректировкаДолга.КредиторскаяЗадолженность.(
		|		ДоговорКонтрагента,
		|		ДоговорКонтрагента.Наименование КАК ДоговорПредставление,
		|		Сумма,
		|		СуммаВзаиморасчетов
		|	)
		|ИЗ
		|	Документ.КорректировкаДолга КАК КорректировкаДолга
		|ГДЕ
		|	КорректировкаДолга.Ссылка В(&МассивОбъектов)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата,
		|	КорректировкаДолга.Ссылка,
		|	КорректировкаДолга.ДебиторскаяЗадолженность.НомерСтроки,
		|	КорректировкаДолга.КредиторскаяЗадолженность.НомерСтроки";
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ПервыйДокумент = Истина;
	
	Пока Шапка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		
		ОбластьМакета.Параметры.Заполнить(Шапка);
		
		СведенияОбОрганизации    = БухгалтерскийУчетСервер.ПолучитьСведенияОбОрганизации(Шапка.Организация, Шапка.Дата);
		ПредставлениеОрганизации = СведенияОбОрганизации.НаименованиеПолное;
		
		СведенияОКонтрагенте     = БухгалтерскийУчетСервер.ПолучитьСведенияОКонтрагенте(Шапка.Кредитор);
		ПредставлениеКредитора   = СведенияОКонтрагенте.НаименованиеПолное;
		
		СтрокаКредиторки = НСтр("ru = '1. Задолженность %ПредставлениеОрганизации% перед %ПредставлениеКредитора% составляет'")+ " ";
		СтрокаКредиторки = СтрЗаменить(СтрокаКредиторки,"%ПредставлениеОрганизации%",ПредставлениеОрганизации);
		СтрокаКредиторки = СтрЗаменить(СтрокаКредиторки,"%ПредставлениеКредитора%",ПредставлениеКредитора);
		Если Шапка.ВалютаДокумента = ВалютаРеглУчета или НЕ ЗначениеЗаполнено(Шапка.ВалютаДокумента) Тогда
			КолонкаСуммы        = "Сумма";
			ПредставлениеВалюты = строка(ВалютаРеглУчета);
		Иначе	
			КолонкаСуммы        = "СуммаВзаиморасчетов";
			ПредставлениеВалюты = строка(Шапка.ВалютаДокумента);
		КонецЕсли; 
		
		ДебиторскаяЗадолженность = Шапка.ДебиторскаяЗадолженность.Выгрузить();
		КредиторскаяЗадолженность = Шапка.КредиторскаяЗадолженность.Выгрузить();
		ДебиторскаяЗадолженность.Свернуть("ДоговорКонтрагента,ДоговорПредставление","Сумма,СуммаВзаиморасчетов");
		ДебиторскаяЗадолженность.Сортировать("ДоговорПредставление,Сумма");
		КредиторскаяЗадолженность.Свернуть("ДоговорКонтрагента,ДоговорПредставление","Сумма,СуммаВзаиморасчетов");
		КредиторскаяЗадолженность.Сортировать("ДоговорПредставление,Сумма");
		
		СтрокаШапки = НСтр("ru = 'Акт взаимозачета № %Номер% от %Дата%'"); 
		СтрокаШапки = СтрЗаменить(СтрокаШапки,"%Номер%", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.Номер, Истина, Ложь));
		СтрокаШапки = СтрЗаменить(СтрокаШапки,"%Дата%",   Формат(Шапка.Дата, "ДЛФ=DD"));
		СтрокаКредиторки  = СтрокаКредиторки + Формат(КредиторскаяЗадолженность.Итог(КолонкаСуммы), "ЧЦ=15; ЧДЦ=2; ЧН=Ноль") + " " + ПредставлениеВалюты + " " +НСтр("ru = 'по следующим договорам:'");
		
		ОбластьМакета.Параметры.СтрокаШапки      = СтрокаШапки;
		ОбластьМакета.Параметры.СтрокаКредиторки = СтрокаКредиторки;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("СтрокаКредиторки");
		Для каждого СтрокаЗадолженности Из КредиторскаяЗадолженность Цикл
			ОбластьМакета.Параметры.СтрокаДокументовКред = сокрЛП(СтрокаЗадолженности.ДоговорПредставление) + " :"+ символы.Таб + Формат(СтрокаЗадолженности[КолонкаСуммы], "ЧЦ=15; ЧДЦ=2; ЧН=Ноль") + " " + ПредставлениеВалюты;
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокДебиторки");
		
		СведенияОКонтрагенте 	= БухгалтерскийУчетСервер.ПолучитьСведенияОКонтрагенте(Шапка.Дебитор);
		ПредставлениеДебитора 	= СведенияОКонтрагенте.НаименованиеПолное;
		
		СтрокаДебиторки       = НСтр("ru = '2. Задолженность %ПредставлениеДебитора% перед %ПредставлениеОрганизации% составляет "
		                      + "%Сумма% %ПредставлениеВалюты% по следующим договорам:'");
		СтрокаДебиторки = СтрЗаменить(СтрокаДебиторки,"%ПредставлениеДебитора%", ПредставлениеДебитора);
		СтрокаДебиторки = СтрЗаменить(СтрокаДебиторки,"%ПредставлениеОрганизации%", ПредставлениеОрганизации);
		СтрокаДебиторки = СтрЗаменить(СтрокаДебиторки,"%ПредставлениеВалюты%", ПредставлениеВалюты);
		СтрокаДебиторки = СтрЗаменить(СтрокаДебиторки,"%Сумма%", Формат(ДебиторскаяЗадолженность.Итог(КолонкаСуммы), "ЧЦ=15; ЧДЦ=2; ЧН=Ноль"));
		
		ОбластьМакета.Параметры.СтрокаДебиторки = СтрокаДебиторки;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("СтрокаДебиторки");
		Для каждого СтрокаЗадолженности Из ДебиторскаяЗадолженность Цикл
			ОбластьМакета.Параметры.СтрокаДокументовДеб = сокрЛП(СтрокаЗадолженности.ДоговорПредставление) + " :" + Символы.Таб + Формат(СтрокаЗадолженности[КолонкаСуммы], "ЧЦ=15; ЧДЦ=2; ЧН=Ноль") + " " + ПредставлениеВалюты;
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
		
		ОбластьПодвала     = Макет.ПолучитьОбласть("Подвал");
		СтрокаВзаимозачета = НСтр("ru = '3. Взаимозачет производится на сумму'")+ " "
		                   + Формат(ДебиторскаяЗадолженность.Итог(КолонкаСуммы), "ЧЦ=15; ЧДЦ=2; ЧН=Ноль") + " " + ПредставлениеВалюты;
		ОбластьПодвала.Параметры.СтрокаВзаимозачета       = СтрокаВзаимозачета;
		ОбластьПодвала.Параметры.ПредставлениеОрганизации = ПредставлениеОрганизации;
		ОбластьПодвала.Параметры.ПредставлениеКредитора   = ПредставлениеКредитора;
		ТабличныйДокумент.Вывести(ОбластьПодвала);
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);

	КонецЦикла;

	Возврат ТабличныйДокумент;

КонецФункции

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	// Проверяем, нужно ли для макета ППИ формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КорректировкаДолга") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"КорректировкаДолга", НСтр("ru = 'Акт взаимозачета'"), ПечатьАктаВзаимозачета(МассивОбъектов, ОбъектыПечати),,
			"Документ.КорректировкаДолга.ПФ_MXL_Взаимозачет");
	КонецЕсли;
		
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Акт взаимозачета
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "КорректировкаДолга";
	КомандаПечати.Представление = НСтр("ru = 'Акт взаимозачета'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "РеестрКорректировкаДолга";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Корректировка долга""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает остатки взаиморасчетов по контрагенту. Выполняется в фоновом задании.
//
Процедура ЗаполнитьОстаткамиВзаиморасчетов(СтруктураПараметров, АдресХранилища) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	СтруктураДанныхЗаполнения = Новый Структура();
	СтруктураДанныхЗаполнения.Вставить("Успешно",            Истина);
	СтруктураДанныхЗаполнения.Вставить("ЗаполненныеТаблицы", Новый Соответствие);
	
	Для каждого ЗаполняемаяТаблица Из СтруктураПараметров.ЗаполняемыеТаблицы Цикл
		
		ТаблицаЗадолженности = ПолучитьОстаткиВзаиморасчетовПоВидуЗадолженности(СтруктураПараметров, ЗаполняемаяТаблица);
		СтруктураДанныхЗаполнения.ЗаполненныеТаблицы.Вставить(ЗаполняемаяТаблица.ВидЗадолженности, ТаблицаЗадолженности);
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(СтруктураДанныхЗаполнения, АдресХранилища);
	
КонецПроцедуры

// Получает остатки взаиморасчетов по контрагенту для одного из видов задолженности.
//
Функция ПолучитьОстаткиВзаиморасчетовПоВидуЗадолженности(СтруктураПараметров, ЗаполняемаяТаблица)

	СчетаРасчетов = Новый Массив();
	СчетаРасчетов.Добавить(ПланыСчетов.Хозрасчетный.СчетаКПолучению); // 1400
	СчетаРасчетов.Добавить(ПланыСчетов.Хозрасчетный.АвансыВыданные); // 1800
	СчетаРасчетов.Добавить(ПланыСчетов.Хозрасчетный.СчетаКОплате); // 3100
	СчетаРасчетов.Добавить(ПланыСчетов.Хозрасчетный.АвансыПолученные); // 3200
	СчетаРасчетов.Добавить(ПланыСчетов.Хозрасчетный.КраткосрочныеДолговыеОбязательства); // 3300
	СчетаРасчетов.Добавить(ПланыСчетов.Хозрасчетный.ДолгосрочныеОбязательства); // 4100

	СчетаИсключаемые = Новый Массив();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ХозрасчетныйВидыСубконто.Ссылка КАК Ссылка,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА ХозрасчетныйВидыСубконто.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты)
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ) КАК ЕстьКонтрагенты,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА ХозрасчетныйВидыСубконто.ВидСубконто = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры)
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ) КАК ЕстьДоговоры
		|ПОМЕСТИТЬ НаличиеНужныхСубконто
		|ИЗ
		|	ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
		|
		|СГРУППИРОВАТЬ ПО
		|	ХозрасчетныйВидыСубконто.Ссылка
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Хозрасчетный.Ссылка КАК СчетаРасчетов
		|ИЗ
		|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ НаличиеНужныхСубконто КАК НаличиеНужныхСубконто
		|		ПО Хозрасчетный.Ссылка = НаличиеНужныхСубконто.Ссылка
		|ГДЕ
		|	НаличиеНужныхСубконто.ЕстьКонтрагенты
		|	И НаличиеНужныхСубконто.ЕстьДоговоры
		|	И НЕ Хозрасчетный.ЗапретитьИспользоватьВПроводках
		|	И Хозрасчетный.Ссылка В ИЕРАРХИИ(&СчетаРасчетов)
		|	И НЕ Хозрасчетный.Ссылка В ИЕРАРХИИ (&СчетаИсключаемые)";

	Запрос.УстановитьПараметр("СчетаРасчетов", СчетаРасчетов);
	Запрос.УстановитьПараметр("СчетаИсключаемые", СчетаИсключаемые);
	СчетаУчетаРасчетов = Запрос.Выполнить().Выгрузить();

	СчетаРасчетов = ОбщегоНазначенияБПВызовСервера.УдалитьПовторяющиесяЭлементыМассива(СчетаУчетаРасчетов.ВыгрузитьКолонку("СчетаРасчетов"), Истина);

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ХозрасчетныйОстатки.Счет КАК Счет,
		|	ХозрасчетныйОстатки.Субконто1 КАК Контрагент,
		|	ХозрасчетныйОстатки.Субконто2 КАК Договор,
		|	ХозрасчетныйОстатки.СуммаОстаток КАК СуммаОстаток,
		|	ХозрасчетныйОстатки.ВалютнаяСуммаОстаток КАК ВалютнаяСуммаОстаток,
		|	ДоговорыКонтрагентов.ВидДоговора КАК ВидДоговора,
		|	ДоговорыКонтрагентов.ВалютаРасчетов КАК ВалютаРасчетов
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Остатки(
		|			&Период,
		|			Счет В (&СчетаРасчетов),
		|			&ВидыСубконто,
		|			Организация = &Организация
		|				И Субконто1 = &Контрагент) КАК ХозрасчетныйОстатки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|		ПО ХозрасчетныйОстатки.Субконто2 = ДоговорыКонтрагентов.Ссылка
		|ГДЕ
		|	ВЫБОР
		|			КОГДА &ВалютаДокумента В (&ВалютаРегУчета)
		|				ТОГДА ДоговорыКонтрагентов.ВалютаРасчетов В (&ВалютаРегУчета)
		|			ИНАЧЕ НЕ ДоговорыКонтрагентов.ВалютаРасчетов В (&ВалютаРегУчета)
		|		КОНЕЦ
		|	И ВЫБОР
		|			КОГДА ДоговорыКонтрагентов.ВалютаРасчетов В (&ВалютаРегУчета)
		|				ТОГДА ВЫБОР
		|						КОГДА &ВидЗадолженности = &ВидЗадолженностиДебиторская
		|							ТОГДА ХозрасчетныйОстатки.СуммаОстаток > 0
		|						ИНАЧЕ ХозрасчетныйОстатки.СуммаОстаток < 0
		|					КОНЕЦ
		|			ИНАЧЕ ВЫБОР
		|					КОГДА &ВидЗадолженности = &ВидЗадолженностиДебиторская
		|						ТОГДА ХозрасчетныйОстатки.ВалютнаяСуммаОстаток > 0
		|					ИНАЧЕ ХозрасчетныйОстатки.ВалютнаяСуммаОстаток < 0
		|				КОНЕЦ
		|		КОНЕЦ";
	Если НЕ ЗаполняемаяТаблица.МассивВидовДоговоров = Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
		|	И ДоговорыКонтрагентов.ВидДоговора В (&МассивВидовДоговоров)";
	КонецЕсли;
	
	ВидЗадолженности = ЗаполняемаяТаблица.ВидЗадолженности;
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Если СтруктураПараметров.ЭтоНовый Тогда
		Запрос.УстановитьПараметр("Период", Новый МоментВремени(КонецДня(СтруктураПараметров.Дата), СтруктураПараметров.Ссылка));
	Иначе
		Запрос.УстановитьПараметр("Период", Новый МоментВремени(СтруктураПараметров.Дата, СтруктураПараметров.Ссылка));
	КонецЕсли;
	Запрос.УстановитьПараметр("Организация",				  СтруктураПараметров.Организация);
	Запрос.УстановитьПараметр("Контрагент", 				  ЗаполняемаяТаблица.ПоКонтрагенту);
	Запрос.УстановитьПараметр("ВидЗадолженности", 			  ВидЗадолженности);
	Запрос.УстановитьПараметр("ВидЗадолженностиДебиторская",  Перечисления.ВидыЗадолженности.Дебиторская);
	Запрос.УстановитьПараметр("МассивВидовДоговоров",         ЗаполняемаяТаблица.МассивВидовДоговоров);
	
	СписокВалютыРеглУчета = Новый СписокЗначений;
	СписокВалютыРеглУчета.Добавить(ВалютаРеглУчета);
	СписокВалютыРеглУчета.Добавить(Справочники.Валюты.ПустаяСсылка());
	Запрос.УстановитьПараметр("ВалютаРегУчета",  СписокВалютыРеглУчета);
	Запрос.УстановитьПараметр("ВалютаДокумента", СтруктураПараметров.ВалютаДокумента);

	Если СписокВалютыРеглУчета.НайтиПоЗначению(СтруктураПараметров.ВалютаДокумента) = Неопределено Тогда
		//Документ в иностранной валюте. Установим отбор только по договорам в нужной валюте
		Запрос.Текст = СтрЗаменить(Запрос.Текст,
							"Организация = &Организация",
							"Организация = &Организация
			|				И Валюта = &ВалютаДокумента");
	КонецЕсли;

	Запрос.УстановитьПараметр("СчетаРасчетов", СчетаРасчетов);

	ВидыСубконто = Новый Массив();
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты);
	ВидыСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры);
	Запрос.УстановитьПараметр("ВидыСубконто",ВидыСубконто);
	
	Если ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская Тогда
		Множитель = 1;
		ИмяТаблицыЗадолженности = "ДебиторскаяЗадолженность";
	Иначе		
		Множитель = -1;
		ИмяТаблицыЗадолженности = "КредиторскаяЗадолженность";
	КонецЕсли;
	ТаблицаЗадолженности = Документы.КорректировкаДолга.ПустаяСсылка()[ИмяТаблицыЗадолженности].ВыгрузитьКолонки();
	
	ВыборкаОстатков = Запрос.Выполнить().Выбрать();
	Пока ВыборкаОстатков.Следующий() Цикл
		
		НоваяСтрока = ТаблицаЗадолженности.Добавить();
		НоваяСтрока.ДоговорКонтрагента = ВыборкаОстатков.Договор;
		НоваяСтрока.ВалютаДоговораКонтрагента = ВыборкаОстатков.ВалютаРасчетов;
		НоваяСтрока.СчетУчетаРасчетов  = ВыборкаОстатков.Счет;
		
		НоваяСтрока.СуммаВзаиморасчетов = Множитель * ВыборкаОстатков.ВалютнаяСуммаОстаток;
		
		ДокументВВалюте          = СписокВалютыРеглУчета.НайтиПоЗначению(СтруктураПараметров.ВалютаДокумента) = Неопределено;
		ДокументВРубляхРасчетыУЕ = СписокВалютыРеглУчета.НайтиПоЗначению(ВыборкаОстатков.ВалютаРасчетов) = Неопределено;
		
		Если ДокументВВалюте Или ДокументВРубляхРасчетыУЕ Тогда
		
			Если ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская Тогда
				ЭтоАванс = ВыборкаОстатков.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком 
				  	  И (БухгалтерскийУчетПовтИсп.СчетВИерархии(ВыборкаОстатков.Счет, ПланыСчетов.Хозрасчетный.АвансыВыданные)
						ИЛИ БухгалтерскийУчетПовтИсп.СчетВИерархии(ВыборкаОстатков.Счет, ПланыСчетов.Хозрасчетный.СчетаКОплате));
			Иначе
				ЭтоАванс = ВыборкаОстатков.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем
					  И (БухгалтерскийУчетПовтИсп.СчетВИерархии(ВыборкаОстатков.Счет, ПланыСчетов.Хозрасчетный.АвансыПолученные)
						ИЛИ БухгалтерскийУчетПовтИсп.СчетВИерархии(ВыборкаОстатков.Счет, ПланыСчетов.Хозрасчетный.СчетаКПолучению));
			КонецЕсли;
			
			Если ЭтоАванс Тогда
				
				НоваяСтрока.КурсВзаиморасчетов = ?(ВыборкаОстатков.ВалютнаяСуммаОстаток = 0,
					НоваяСтрока.КурсВзаиморасчетов,
					Окр(ВыборкаОстатков.СуммаОстаток / ВыборкаОстатков.ВалютнаяСуммаОстаток, 4));
				НоваяСтрока.КратностьВзаиморасчетов = 1;
				
			Иначе
				
				Если СписокВалютыРеглУчета.НайтиПоЗначению(СтруктураПараметров.ВалютаДокумента) = Неопределено Тогда
				
					НоваяСтрока.КурсВзаиморасчетов = СтруктураПараметров.КурсДокумента;
					НоваяСтрока.КратностьВзаиморасчетов = СтруктураПараметров.КратностьДокумента;
					
				Иначе
					
					КурсИКратность = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВыборкаОстатков.ВалютаРасчетов, СтруктураПараметров.Дата);
					
					НоваяСтрока.КурсВзаиморасчетов = КурсИКратность.Курс;
					НоваяСтрока.КратностьВзаиморасчетов = КурсИКратность.Кратность;
					
				КонецЕсли;	
				
			КонецЕсли;
			
			Если ВыборкаОстатков.РасчетыВУсловныхЕдиницах Тогда
				
				Если ЭтоАванс Тогда
					НоваяСтрока.Сумма = Множитель * ВыборкаОстатков.СуммаОстаток;
				Иначе	
					
					НоваяСтрока.Сумма = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(НоваяСтрока.СуммаВзаиморасчетов,
						ВыборкаОстатков.ВалютаРасчетов, ВалютаРеглУчета,
						НоваяСтрока.КурсВзаиморасчетов, 1,
						НоваяСтрока.КратностьВзаиморасчетов, 1);
					
				КонецЕсли;	
				
			Иначе
				НоваяСтрока.Сумма = НоваяСтрока.СуммаВзаиморасчетов;
			КонецЕсли;

		Иначе
			
			НоваяСтрока.СуммаВзаиморасчетов 	= Множитель * ВыборкаОстатков.СуммаОстаток;
			НоваяСтрока.КурсВзаиморасчетов 		= 1;
			НоваяСтрока.КратностьВзаиморасчетов = 1;
			
			НоваяСтрока.Сумма = Множитель * ВыборкаОстатков.СуммаОстаток;
			
		КонецЕсли;		
	КонецЦикла;
	
	Возврат ТаблицаЗадолженности;

КонецФункции

#КонецОбласти

#КонецЕсли
