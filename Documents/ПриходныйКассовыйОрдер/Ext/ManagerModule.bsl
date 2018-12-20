﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру бухгалтерии Хозрасчетный.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	// 1. Оплата от покупателя, Возврат от поставщика, Расчеты по займам
	// 2. Возврат от сотрудника
	// 3. Возврат от подотчетника
	// 4. Получение наличных в банке
	// 5. Прочий приход
	// 6. Конвертация
	
	// Оплата от покупателя, Возврат от поставщика, Расчеты по займам.
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	1 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетДт,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК СчетКт,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоДт1,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.Контрагент КАК СубконтоКт1,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	ВременнаяТаблицаШапка.ВалютаРасчетов КАК ВалютаКт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаВзаиморасчетов КАК ВалютнаяСуммаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации) КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	(ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ОплатаОтПокупателя)
		|			ИЛИ ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ВозвратОтПоставщика)
		|			ИЛИ ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.РасчетыПоЗаймам))";
	ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|";
	
	// Возврат от сотрудника.
	ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	2 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетДт,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НачисленнаяЗаработнаяПлата) КАК СчетКт,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоДт1,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.ФизЛицо КАК СубконтоКт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаДт,
		|	0 КАК ВалютнаяСуммаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации) КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ВозвратОтСотрудника)";
	ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|";
	
	// Возврат от подотчетника.
	ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	3 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетДт,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК СчетКт,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоДт1,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.ФизЛицо КАК СубконтоКт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаКт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации) КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ВозвратОтПодотчетника)";
	ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|";
	
	// Получение наличных в банке.
	ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	4 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетДт,
		|	ВременнаяТаблицаШапка.БанковскийСчет.СчетУчета КАК СчетКт,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоДт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.БанковскийСчет КАК СубконтоКт1,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	ВременнаяТаблицаШапка.ВалютаРасчетов КАК ВалютаКт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаВзаиморасчетов КАК ВалютнаяСуммаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации) КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ПолучениеНаличныхВБанке)";
	ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|";
	
	// Прочий приход.
	ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	5 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетДт,
		|	ВременнаяТаблицаПрочиеПлатежи.СчетРасчетов КАК СчетКт,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоДт1,
		|	ВременнаяТаблицаПрочиеПлатежи.СтатьяДвиженияДенежныхСредств КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаПрочиеПлатежи.Субконто1 КАК СубконтоКт1,
		|	ВременнаяТаблицаПрочиеПлатежи.Субконто2 КАК СубконтоКт2,
		|	ВременнаяТаблицаПрочиеПлатежи.Субконто3 КАК СубконтоКт3,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаКт,
		|	ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа КАК ВалютнаяСуммаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации) КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаПрочиеПлатежи КАК ВременнаяТаблицаПрочиеПлатежи
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ПрочийПриход)";
	ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|";
	
	// Конвертация.
	ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	6 КАК Порядок,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК СчетДт,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК СчетКт,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоДт1,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВременнаяТаблицаШапка.Касса КАК СубконтоКт1,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа
		|		ИНАЧЕ ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|	КОНЕЦ КАК Сумма,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДт,
		|	ВременнаяТаблицаШапка.ВалютаРасчетов КАК ВалютаКт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа КАК ВалютнаяСуммаДт,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СуммаВзаиморасчетов КАК ВалютнаяСуммаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВременнаяТаблицаШапка.ВидОперации) КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.Конвертация)";
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстЗапроса;
	РезультатЗапроса = Запрос.Выполнить();	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаХозрасчетный", РезультатЗапроса.Выгрузить());
	
	// Подготовка таблицы для расчета операционных курсовых разниц.
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Контрагент КАК Контрагент,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ВременнаяТаблицаШапка.Касса КАК КассаБанковскийСчет,
		|	ВременнаяТаблицаШапка.Касса КАК КассаБанковскийСчетПриход,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.Конвертация)
		|			ТОГДА ВременнаяТаблицаШапка.Касса
		|		ИНАЧЕ ВременнаяТаблицаШапка.БанковскийСчет
		|	КОНЕЦ КАК КассаБанковскийСчетРасход,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК СчетРасчетов,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета КАК ДенежныйСчет,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаДокумента,
		|	ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,
		|	ВременнаяТаблицаШапка.ВалютаРасчетов КАК ВалютаРасчетов,
		|	ВременнаяТаблицаШапка.Курс КАК КурсДокумента,
		|	ВременнаяТаблицаШапка.Кратность КАК КратностьДокумента,
		|	СУММА(ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа) КАК СуммаПлатежа,
		|	СУММА(ВременнаяТаблицаРасшифровкаПлатежа.СуммаВзаиморасчетов) КАК СуммаВзаиморасчетов,
		|	ВременнаяТаблицаКурсыВалют.Курс КАК КурсВзаиморасчетовПоНацБанку,
		|	ВременнаяТаблицаКурсыВалют.Кратность КАК КратностьВзаиморасчетовПоНацБанку
		|ИЗ
		|	ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаКурсыВалют КАК ВременнаяТаблицаКурсыВалют
		|		ПО (ИСТИНА)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаУчетаСОсобымПорядкомПереоценки КАК СчетаУчетаСОсобымПорядкомПереоценки
		|		ПО ВременнаяТаблицаШапка.Касса.СчетУчета = СчетаУчетаСОсобымПорядкомПереоценки.СчетУчета
		|ГДЕ
		|	НЕ ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаДокумента
		|	И НЕ ВременнаяТаблицаШапка.КурсВзаиморасчетов = ВременнаяТаблицаКурсыВалют.Курс
		|	И НЕ ЕСТЬNULL(СчетаУчетаСОсобымПорядкомПереоценки.НеСчитатьОКР, ЛОЖЬ) = ИСТИНА
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаКурсыВалют.Курс,
		|	ВременнаяТаблицаКурсыВалют.Кратность,
		|	ВременнаяТаблицаШапка.Контрагент,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.Конвертация)
		|			ТОГДА ВременнаяТаблицаШапка.Касса
		|		ИНАЧЕ ВременнаяТаблицаШапка.БанковскийСчет
		|	КОНЕЦ,
		|	ВременнаяТаблицаШапка.СчетРасчетов,
		|	ВременнаяТаблицаШапка.Курс,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.Касса,
		|	ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета,
		|	ВременнаяТаблицаШапка.ВалютаРасчетов,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаШапка.Касса.СчетУчета,
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Кратность";

	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДляРасчетаОперационныхКурсовыхРазниц", Запрос.Выполнить().Выгрузить());
КонецПроцедуры // СформироватьТаблицаХозрасчетный()

// Формирует таблицу значений, содержащую данные для проведения по регистру накопления ДвиженияДенежныхСредств.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаДвиженияДенежныхСредств(СтруктураДополнительныеСвойства)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств КАК Статья,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	НЕ ВременнаяТаблицаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств = ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПустаяСсылка)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаПрочиеПлатежи.СтатьяДвиженияДенежныхСредств,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаПрочиеПлатежи.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаПрочиеПлатежи КАК ВременнаяТаблицаПрочиеПлатежи
		|		ПО (ИСТИНА)
		|ГДЕ
		|	НЕ ВременнаяТаблицаПрочиеПлатежи.СтатьяДвиженияДенежныхСредств = ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПустаяСсылка)";
	РезультатЗапроса = Запрос.Выполнить();	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДвиженияДенежныхСредств", РезультатЗапроса.Выгрузить());
КонецПроцедуры

// Формирует таблицу значений, содержащую данные для проведения по регистру накопления ВозвратДенежныхСредствПодотчетником.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаОтразитьВозвратПодотчетником(СтруктураДополнительныеСвойства)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.ФизЛицо КАК ФизЛицо,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ВозвратОтПодотчетника)";	
	РезультатЗапроса = Запрос.Выполнить();	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаОтразитьВозвратПодотчетником", РезультатЗапроса.Выгрузить());
КонецПроцедуры

// Формирует таблицу значений, содержащую данные для проведения по регистру "АвансыПодотчетника".
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаАвансыПодотчетника(ДокументСсылка,СтруктураДополнительныеСвойства)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Ссылка КАК Документ,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.ФизЛицо КАК ФизЛицо,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК Валюта,
		|	-ВременнаяТаблицаШапка.СуммаДокумента КАК Сумма
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|ГДЕ
		|	ВременнаяТаблицаШапка.ВидОперации =  ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ВозвратОтПодотчетника)";	
	РезультатЗапроса = Запрос.Выполнить();	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаАвансыПодотчетника", РезультатЗапроса.Выгрузить());
КонецПроцедуры

// Формирует таблицу значений, содержащую данные для проведения по регистру накопления ОборотыПоДаннымЕдиногоНалога.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаОтразитьОборотыПоДаннымЕдиногоНалога(СтруктураДополнительныеСвойства)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаРасшифровкаПлатежа.ВидДеятельности КАК ВидДеятельности,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.ВалютаДокумента = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа
		|		КОГДА ВременнаяТаблицаШапка.ВалютаРасчетов = ВременнаяТаблицаШапка.ВалютаРегламентированногоУчета
		|			ТОГДА ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.КурсВзаиморасчетов / ВременнаяТаблицаШапка.КратностьВзаиморасчетов
		|		ИНАЧЕ ВременнаяТаблицаРасшифровкаПлатежа.СуммаПлатежа * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность
		|	КОНЕЦ КАК СуммаНаличная
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаРасшифровкаПлатежа КАК ВременнаяТаблицаРасшифровкаПлатежа
		|		ПО (ИСТИНА)
		|ГДЕ
		|	&ПлательщикЕН
		|	И ВременнаяТаблицаШапка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПКО.ОплатаОтПокупателя)";
	Запрос.УстановитьПараметр("ПлательщикЕН", СтруктураДополнительныеСвойства.УчетнаяПолитика.ПлательщикЕН);	
	РезультатЗапроса = Запрос.Выполнить();	
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ОборотыПоДаннымЕдиногоНалога", РезультатЗапроса.Выгрузить());
КонецПроцедуры

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка КАК Ссылка,
		|	ТаблицаДокумента.Дата КАК Дата,
		|	ТаблицаДокумента.Организация КАК Организация,
		|	ТаблицаДокумента.ВидОперации КАК ВидОперации,
		|	ТаблицаДокумента.Касса КАК Касса,
		|	ТаблицаДокумента.ВалютаДокумента КАК ВалютаДокумента,
		|	ТаблицаДокумента.Курс КАК Курс,
		|	ТаблицаДокумента.Кратность КАК Кратность,
		|	ТаблицаДокумента.Контрагент КАК Контрагент,
		|	ТаблицаДокумента.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ТаблицаДокумента.ВалютаРасчетов КАК ВалютаРасчетов,
		|	ТаблицаДокумента.СчетРасчетов КАК СчетРасчетов,
		|	ТаблицаДокумента.КурсВзаиморасчетов КАК КурсВзаиморасчетов,
		|	ТаблицаДокумента.КратностьВзаиморасчетов КАК КратностьВзаиморасчетов,
		|	ТаблицаДокумента.ФизЛицо КАК ФизЛицо,
		|	ТаблицаДокумента.БанковскийСчет КАК БанковскийСчет,
		|	ТаблицаДокумента.СуммаДокумента КАК СуммаДокумента,
		|	&ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ПриходныйКассовыйОрдер КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.ВидДеятельности КАК ВидДеятельности,
		|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
		|	ТаблицаДокумента.СуммаПлатежа КАК СуммаПлатежа,
		|	ТаблицаДокумента.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов
		|ПОМЕСТИТЬ ВременнаяТаблицаРасшифровкаПлатежа
		|ИЗ
		|	Документ.ПриходныйКассовыйОрдер.РасшифровкаПлатежа КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
		|	ТаблицаДокумента.СуммаПлатежа КАК СуммаПлатежа,
		|	ТаблицаДокумента.СчетРасчетов КАК СчетРасчетов,
		|	ТаблицаДокумента.Субконто1 КАК Субконто1,
		|	ТаблицаДокумента.Субконто2 КАК Субконто2,
		|	ТаблицаДокумента.Субконто3 КАК Субконто3
		|ПОМЕСТИТЬ ВременнаяТаблицаПрочиеПлатежи
		|ИЗ
		|	Документ.ПриходныйКассовыйОрдер.ПрочиеПлатежи КАК ТаблицаДокумента
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
		|	РегистрСведений.КурсыВалют.СрезПоследних(&Период, Валюта = &ВалютаРасчетов) КАК КурсыВалютСрезПоследних";				
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);	
	Запрос.УстановитьПараметр("Период", СтруктураДополнительныеСвойства.ДляПроведения.Дата);	
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРегламентированногоУчета);	
	Запрос.УстановитьПараметр("ВалютаРасчетов", 
	?(СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРасчетов = СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРегламентированногоУчета,
		СтруктураДополнительныеСвойства.ДляПроведения.ВалютаДокумента, 
		СтруктураДополнительныеСвойства.ДляПроведения.ВалютаРасчетов));	

	Запрос.Выполнить();
	
	СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаДвиженияДенежныхСредств(СтруктураДополнительныеСвойства);
	СформироватьТаблицаОтразитьВозвратПодотчетником(СтруктураДополнительныеСвойства);
	СформироватьТаблицаАвансыПодотчетника(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаОтразитьОборотыПоДаннымЕдиногоНалога(СтруктураДополнительныеСвойства);
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

// Функция формирует табличный документ с печатной формой Кассовый ордер форма №1
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьКассовыйОрдер(МассивОбъектов, ОбъектыПечати)
	
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ХозрасчетныйДвиженияССубконто.Регистратор КАК Регистратор,
		|	ХозрасчетныйДвиженияССубконто.СчетДт.Код КАК СчетДт,
		|	ХозрасчетныйДвиженияССубконто.СчетКт.Код КАК СчетКт
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(
		|			,
		|			,
		|			Регистратор В (&СписокДокументов)
		|				И СчетДт <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ДоходыОтОперационныхКурсовыхРазниц)
		|				И СчетДт <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.УбыткиОтОперационныхКурсовыхРазниц)
		|				И СчетКт <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ДоходыОтОперационныхКурсовыхРазниц)
		|				И СчетКт <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.УбыткиОтОперационныхКурсовыхРазниц)) КАК ХозрасчетныйДвиженияССубконто
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПриходныйКассовыйОрдер.Ссылка КАК Ссылка,
		|	ПриходныйКассовыйОрдер.Номер КАК Номер,
		|	ПриходныйКассовыйОрдер.Дата КАК Дата,
		|	ПриходныйКассовыйОрдер.Касса КАК Касса,
		|	&ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,
		|	ПриходныйКассовыйОрдер.ВалютаДокумента КАК ВалютаДокумента,
		|	ПриходныйКассовыйОрдер.ВалютаДокумента.Наименование КАК ВалютаНаименование,
		|	ПриходныйКассовыйОрдер.Курс КАК Курс,
		|	ПриходныйКассовыйОрдер.Кратность КАК Кратность,
		|	ПриходныйКассовыйОрдер.СуммаДокумента КАК СуммаДокумента,
		|	ПриходныйКассовыйОрдер.Организация КАК Организация,
		|	ПриходныйКассовыйОрдер.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	ПриходныйКассовыйОрдер.Организация.КодПоОКПО КАК ОрганизацияКодПоОКПО,
		|	ПриходныйКассовыйОрдер.ПринятоОт КАК ПринятоОт,
		|	ПриходныйКассовыйОрдер.Основание КАК Основание,
		|	ПриходныйКассовыйОрдер.Приложение КАК Приложение
		|ИЗ
		|	Документ.ПриходныйКассовыйОрдер КАК ПриходныйКассовыйОрдер
		|ГДЕ
		|	ПриходныйКассовыйОрдер.Ссылка В(&СписокДокументов)";		
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаСчетов = МассивРезультатов[0].Выгрузить();
	ТаблицаСчетов.Индексы.Добавить("Регистратор");
	
	Шапка = МассивРезультатов[1].Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПриходныйКассовыйОрдер_КассовыйОрдер";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПриходныйКассовыйОрдер.ПФ_MXL_КассовыйОрдер");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		
		ДанныеПечати.Вставить("ДатаДокумента", Формат(Шапка.Дата, "ДЛФ=D"));
		НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.Номер);
		ДанныеПечати.Вставить("НомерДокумента", НомерНаПечать);
		ДанныеПечати.Вставить("ОрганизацияНаименованиеПолное", Шапка.ОрганизацияНаименованиеПолное);
		ДанныеПечати.Вставить("ОрганизацияКодПоОКПО", Шапка.ОрганизацияКодПоОКПО);
		ДанныеПечати.Вставить("ВалютаНаименование", Шапка.ВалютаНаименование);
		Если НЕ Шапка.ВалютаДокумента = Шапка.ВалютаРегламентированногоУчета Тогда
			ДанныеПечати.Вставить("РасшифровкаКурса", СтрШаблон(НСтр("ru = 'Курс: %1'"), Шапка.Курс / Шапка.Кратность));
		КонецЕсли;	
		
		// Формирование счетов Дт и Кт.
		СтрокаСчетДт = "";
		СтрокаСчетКт = "";
		НайденныеСтроки = ТаблицаСчетов.НайтиСтроки(Новый Структура("Регистратор", Шапка.Ссылка));
		Для Каждого НайденнаяСтрокаТаблицы Из НайденныеСтроки Цикл
			Если СтрНайти(СтрокаСчетДт, НайденнаяСтрокаТаблицы.СчетДт) = 0 Тогда
				Если НЕ СтрокаСчетДт = "" Тогда 
					СтрокаСчетДт = СтрокаСчетДт + ", ";
				КонецЕсли;	
				СтрокаСчетДт = СтрокаСчетДт + НайденнаяСтрокаТаблицы.СчетДт;		
			КонецЕсли;
		
			Если СтрНайти(СтрокаСчетКт, НайденнаяСтрокаТаблицы.СчетКт) = 0 Тогда   
				Если НЕ СтрокаСчетКт = "" Тогда 
					СтрокаСчетКт = СтрокаСчетКт + ", ";
				КонецЕсли;	
				СтрокаСчетКт = СтрокаСчетКт + НайденнаяСтрокаТаблицы.СчетКт;
			КонецЕсли;	
		КонецЦикла;		

		ДанныеПечати.Вставить("СчетДт", СтрокаСчетДт);
		ДанныеПечати.Вставить("СчетКт", СтрокаСчетКт);
		
		ДанныеПечати.Вставить("ПринятоОт", Шапка.ПринятоОт);
		ДанныеПечати.Вставить("Основание", Шапка.Основание);
		ДанныеПечати.Вставить("Приложение", Шапка.Приложение);
		
		ДанныеПечати.Вставить("СуммаДокумента", Формат(Шапка.СуммаДокумента, "ЧЦ=15; ЧДЦ=2; ЧГ=3,0"));
		ДанныеПечати.Вставить("СуммаПрописью", БухгалтерскийУчетСервер.СформироватьСуммуПрописью(Шапка.СуммаДокумента, Шапка.ВалютаДокумента));
		
		// Подписи.
		ФамилияИОГлавногоБухгалтера = "";
		ФамилияИОКассира = "";
		ОтветственныеЛица = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Шапка.Организация, Шапка.Дата, Новый Структура("Касса", Шапка.Касса));
		БухгалтерскийУчетСервер.ФамилияИнициалыПоНаименованию(ФамилияИОГлавногоБухгалтера, ОтветственныеЛица.ГлавныйБухгалтер);
		БухгалтерскийУчетСервер.ФамилияИнициалыПоНаименованию(ФамилияИОКассира, ОтветственныеЛица.Кассир);
		
		ДанныеПечати.Вставить("ФамилияИОГлавногоБухгалтера", ФамилияИОГлавногоБухгалтера);
		ДанныеПечати.Вставить("ФамилияИОКассира", ФамилияИОКассира);
		
		// Области
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Заголовок");
		
		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
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
	
	// Проверяем, нужно ли для макета ПКО формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_КассовыйОрдер") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"ПФ_MXL_КассовыйОрдер", НСтр("ru = 'Печать ПКО'"), ПечатьКассовыйОрдер(МассивОбъектов, ОбъектыПечати),,
			"Документ.ПриходныйКассовыйОрдер.ПФ_MXL_КассовыйОрдер");
	КонецЕсли;	
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПФ_MXL_КассовыйОрдер";
	КомандаПечати.Представление = НСтр("ru = 'Печать ПКО'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "РеестрПриходныйКассовыйОрдер";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Приходный кассовый ордер""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
КонецПроцедуры

#КонецОбласти

#КонецЕсли