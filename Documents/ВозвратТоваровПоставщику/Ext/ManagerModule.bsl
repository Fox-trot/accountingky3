﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПроцедурыПроведенияДокумента

// Формирует таблицу значений, содержащую данные для проведения по регистру бухгалтерии Хозрасчетный.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства, Отказ)
	
	ПрямыеПроводки = ДокументСсылка.ПрямыеПроводки;
	
	// Подготовка данных	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Ссылка КАК Регистратор,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Склад КАК Склад,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК ВалютаВзаиморасчетов,
		|	&Содержание КАК Содержание
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	""Товары"" КАК ИмяСписка,
		|	&СинонимСписка КАК СинонимСписка,
		|	ВременнаяТаблицаТовары.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаТовары.СчетУчета КАК СчетУчета,
		|	ВременнаяТаблицаТовары.Номенклатура КАК Номенклатура,
		|	ВременнаяТаблицаШапка.Склад КАК Склад,
		|	НЕОПРЕДЕЛЕНО КАК Партия,
		|	0 КАК Себестоимость,
		|	ВременнаяТаблицаТовары.Количество КАК Количество,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК КорСчетСписания,
		|	ВременнаяТаблицаШапка.Контрагент КАК КорСубконто1,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента КАК КорСубконто2,
		|	НЕОПРЕДЕЛЕНО КАК КорСубконто3,
		|	0 КАК СуммаСписания,
		|	&Содержание КАК Содержание,
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	НЕОПРЕДЕЛЕНО КАК ДокументОприходования,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаТовары.Сумма * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК Сумма,
		|	ВременнаяТаблицаТовары.Сумма КАК СуммаВзаиморасчетов,
		|	ИСТИНА КАК СебестоимостьУказанаВДокументе
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ПО (ИСТИНА)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Запрос.УстановитьПараметр("Содержание", НСтр("ru = 'Возврат товаров поставщику'")); 
	Запрос.УстановитьПараметр("СинонимСписка", НСтр("ru = 'Товары'"));
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаРеквизиты = МассивРезультатов[0].Выгрузить(); 
	ТаблицаТовары = МассивРезультатов[1].Выгрузить();
	
	ТаблицаСписанныеТовары = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ТаблицаТовары, ТаблицаРеквизиты, Отказ);
	
	// Если проводки не прямые, т.е. 1610-3110 то суммы записываются с минусом, т.к. это возврат.
	// Также необходимо поменять местами счета и их субконто, это делается в общем модуле 
	// "УчетТоваров", процедура "СформироватьДвиженияВозвратТоваровПоставщику".
	Если НЕ ПрямыеПроводки Тогда	
		Для Каждого СтрокаТаблицы Из ТаблицаСписанныеТовары Цикл	
			СтрокаТаблицы.СуммаСписания = -СтрокаТаблицы.СуммаСписания;	
		КонецЦикла;		
	КонецЕсли;	
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеквизиты", ТаблицаРеквизиты);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаТовары", ТаблицаТовары);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСписанныеТовары", ТаблицаСписанныеТовары);

	// Корректировка себестоимости и НДС
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		// 1. Распределение сумм на себестоимость и сумму НДС
		// 2. Итог сумм по пункту 1
		// 3. СуммаСписания из сформированной таблицы "ТаблицаСписанныеТовары" 
		// 4. Итог по СуммаСписания из 3 пункта
		// 5. Соединение пункта 2 и данных из шапки документа
		// 6. Формирование данных для проводок по корректировки себестоимости возвращаемых товаров и по НДС
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаТовары.ЗачетНДС = ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Себестоимость)
		|			ТОГДА ВременнаяТаблицаТовары.Сумма + ВременнаяТаблицаТовары.СуммаНДС + ВременнаяТаблицаТовары.СуммаНСП
		|		ИНАЧЕ ВременнаяТаблицаТовары.Сумма + ВременнаяТаблицаТовары.СуммаНСП
		|	КОНЕЦ КАК Сумма,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаТовары.ЗачетНДС = ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Себестоимость)
		|			ТОГДА 0
		|		ИНАЧЕ ВременнаяТаблицаТовары.СуммаНДС
		|	КОНЕЦ КАК СуммаНДС
		|ПОМЕСТИТЬ ВременнаяТаблицаРаспределенныеСуммы
		|ИЗ
		|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|;
		|
		|////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(ВременнаяТаблицаСуммы.Сумма) КАК Сумма,
		|   СУММА(ВременнаяТаблицаСуммы.СуммаНДС) КАК СуммаНДС
		|ПОМЕСТИТЬ ВременнаяТаблицаГотовыеСуммы
		|ИЗ
		|	ВременнаяТаблицаРаспределенныеСуммы КАК ВременнаяТаблицаСуммы
		|;
		|
		|////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаСписанныеТовары.СуммаСписания КАК Сумма
		|ПОМЕСТИТЬ ВременнаяТаблицаСписанныеТовары
		|ИЗ
		|	&ТаблицаСписанныеТовары КАК ТаблицаСписанныеТовары
		|;
		|
		|////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(ВременнаяТаблицаСписанныеТовары.Сумма) КАК Сумма
		|ПОМЕСТИТЬ ВременнаяТаблицаСуммаСписанныхТоваров
		|ИЗ
		|	ВременнаяТаблицаСписанныеТовары КАК ВременнаяТаблицаСписанныеТовары
		|;
		|
		|////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.СчетРасчетов КАК СчетРасчетов,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасходыПоВозвратамПоставщикам) КАК СчетРасходов,
		|	ВременнаяТаблицаШапка.Контрагент КАК Контрагент,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ВременнаяТаблицаШапка.ВалютаДокумента КАК Валюта,
		|	ВременнаяТаблицаГотовыеСуммы.Сумма КАК Сумма,
		|	ВременнаяТаблицаШапка.Курс КАК Курс,
		|	ВременнаяТаблицаШапка.Кратность КАК Кратность,
		|	&СодержаниеКорректировка КАК Содержание
		|ПОМЕСТИТЬ ВременнаяТаблицаСуммаВозвратаСДанными
		|ИЗ
		|	ВременнаяТаблицаГотовыеСуммы КАК ВременнаяТаблицаГотовыеСуммы	
		|   	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)
		|;
		|
		|////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаСуммаВозвратаСДанными.Период КАК Период,
		|	ТаблицаСуммаВозвратаСДанными.Организация КАК Организация,
		|	ВЫБОР
		|		КОГДА &ПрямыеПроводки
		|			ТОГДА ТаблицаСуммаВозвратаСДанными.СчетРасчетов 
		|		ИНАЧЕ ТаблицаСуммаВозвратаСДанными.СчетРасходов
		|	КОНЕЦ КАК СчетДт,
		|	ВЫБОР
		|		КОГДА &ПрямыеПроводки
		|			ТОГДА ТаблицаСуммаВозвратаСДанными.СчетРасходов 
		|		ИНАЧЕ ТаблицаСуммаВозвратаСДанными.СчетРасчетов
		|	КОНЕЦ КАК СчетКт,
		|	ВЫБОР
		|		КОГДА &ПрямыеПроводки
		|			ТОГДА ТаблицаСуммаВозвратаСДанными.Контрагент
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК СубконтоДт1,
		|	ВЫБОР
		|		КОГДА &ПрямыеПроводки
		|			ТОГДА ТаблицаСуммаВозвратаСДанными.ДоговорКонтрагента
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК СубконтоДт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
		|	ВЫБОР
		|		КОГДА &ПрямыеПроводки
		|			ТОГДА НЕОПРЕДЕЛЕНО
		|		ИНАЧЕ ТаблицаСуммаВозвратаСДанными.Контрагент 
		|	КОНЕЦ КАК СубконтоКт1,
		|	ВЫБОР
		|		КОГДА &ПрямыеПроводки
		|			ТОГДА НЕОПРЕДЕЛЕНО
		|		ИНАЧЕ ТаблицаСуммаВозвратаСДанными.ДоговорКонтрагента
		|	КОНЕЦ КАК СубконтоКт2,
		|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
		|	ТаблицаСуммаВозвратаСДанными.Валюта КАК ВалютаДт,
		|	ТаблицаСуммаВозвратаСДанными.Валюта КАК ВалютаКт,
		|	ВЫБОР
		|		КОГДА &ПрямыеПроводки
		|			ТОГДА ВЫРАЗИТЬ((ТаблицаСуммаВозвратаСДанными.Сумма - ТаблицаСуммаСписанныхТоваров.Сумма) * ТаблицаСуммаВозвратаСДанными.Курс / ТаблицаСуммаВозвратаСДанными.Кратность КАК ЧИСЛО(15, 2)) 
		|		ИНАЧЕ ВЫРАЗИТЬ(-(ТаблицаСуммаСписанныхТоваров.Сумма + ТаблицаСуммаВозвратаСДанными.Сумма) * ТаблицаСуммаВозвратаСДанными.Курс / ТаблицаСуммаВозвратаСДанными.Кратность КАК ЧИСЛО(15, 2))
		|	КОНЕЦ КАК Сумма,
		|	ВЫБОР
		|		КОГДА &ПрямыеПроводки
		|			ТОГДА ТаблицаСуммаВозвратаСДанными.Сумма - ТаблицаСуммаСписанныхТоваров.Сумма
		|		ИНАЧЕ -(ТаблицаСуммаСписанныхТоваров.Сумма + ТаблицаСуммаВозвратаСДанными.Сумма)
		|	КОНЕЦ КАК ВалютнаяСуммаДт,
		|	ВЫБОР
		|		КОГДА &ПрямыеПроводки
		|			ТОГДА ТаблицаСуммаВозвратаСДанными.Сумма - ТаблицаСуммаСписанныхТоваров.Сумма
		|		ИНАЧЕ -(ТаблицаСуммаСписанныхТоваров.Сумма + ТаблицаСуммаВозвратаСДанными.Сумма)
		|	КОНЕЦ КАК ВалютнаяСуммаКт,
		|	ТаблицаСуммаВозвратаСДанными.Содержание КАК Содержание,
		|	0 КАК КоличествоДт,
		|	0 КАК КоличествоКт
		|ИЗ
		|	ВременнаяТаблицаСуммаВозвратаСДанными КАК ТаблицаСуммаВозвратаСДанными	
		|   	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаСуммаСписанныхТоваров КАК ТаблицаСуммаСписанныхТоваров
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВЫБОР
		|		КОГДА &ПрямыеПроводки
		|			ТОГДА (ТаблицаСуммаВозвратаСДанными.Сумма - ТаблицаСуммаСписанныхТоваров.Сумма) <> 0
		|		ИНАЧЕ (ТаблицаСуммаСписанныхТоваров.Сумма + ТаблицаСуммаВозвратаСДанными.Сумма) <> 0
		|	КОНЕЦ
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|	
		|ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.СчетРасчетов,
		|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НДС_ПодлежащийВозмещению),
		|	ВременнаяТаблицаШапка.Контрагент,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	НЕОПРЕДЕЛЕНО,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВременнаяТаблицаШапка.ВалютаДокумента,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаГотовыеСуммы.СуммаНДС * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)),
		|	ВременнаяТаблицаГотовыеСуммы.СуммаНДС,
		|	ВременнаяТаблицаГотовыеСуммы.СуммаНДС,
		|	&СодержаниеНДС,
		|	0,
		|	0
		|ИЗ
		|	ВременнаяТаблицаГотовыеСуммы КАК ВременнаяТаблицаГотовыеСуммы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)
		|ГДЕ
		|	НЕ ВременнаяТаблицаГотовыеСуммы.СуммаНДС = 0";
	Запрос.УстановитьПараметр("ТаблицаСписанныеТовары", ТаблицаСписанныеТовары);
	Запрос.УстановитьПараметр("ПрямыеПроводки", ПрямыеПроводки);
	Запрос.УстановитьПараметр("СодержаниеКорректировка", НСтр("ru = 'Корректировка суммы возврата'"));
	Запрос.УстановитьПараметр("СодержаниеНДС", НСтр("ru = 'Возврат товаров поставщику (НДС)'")); 	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаХозрасчетный", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры

// Формирует таблицу значений, содержащую данные для проведения по регистру бухгалтерии Хозрасчетный.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаПоступлениеТоваров(ДокументСсылка, СтруктураДополнительныеСвойства) 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.Контрагент,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
		|	ВременнаяТаблицаТовары.Номенклатура,
		|	ВременнаяТаблицаШапка.ЗначениеСтавкиНДС,
		|	ВременнаяТаблицаШапка.ЗначениеСтавкиНСП,
		|	ВременнаяТаблицаШапка.БезналичныйРасчет,
		|	-ВЫРАЗИТЬ(ВременнаяТаблицаТовары.СуммаНДС * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК СуммаНДС,
		|	-ВЫРАЗИТЬ(ВременнаяТаблицаТовары.Сумма * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК Сумма,
		|	-ВЫРАЗИТЬ(ВременнаяТаблицаТовары.СуммаНСП * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК СуммаНСП,
		|	-ВременнаяТаблицаТовары.Количество КАК Количество
		|ИЗ
		|	ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ПО (ИСТИНА)";
	РезультатЗапроса = Запрос.Выполнить();
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПоступлениеТоваров", РезультатЗапроса.Выгрузить());
		
КонецПроцедуры 

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаСведенияОПоступлении(СтруктураДополнительныеСвойства) 
	                   
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Ссылка КАК ДокументСсылка,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Контрагент,
		|	ВременнаяТаблицаШапка.ДоговорКонтрагента,
		|	ВременнаяТаблицаШапка.Дата КАК ДатаПоставки,
		|	ВременнаяТаблицаШапка.СерияБланкаСФ,
		|	ВременнаяТаблицаШапка.НомерБланкаСФ,
		|	ВременнаяТаблицаШапка.ДатаСФ,
		|	ВременнаяТаблицаШапка.ПризнакСтраны,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаТовары.Сумма * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК Сумма,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаТовары.СуммаНДС * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК СуммаНДС,
		|	ВЫРАЗИТЬ(ВременнаяТаблицаТовары.СуммаНСП * ВременнаяТаблицаШапка.Курс / ВременнаяТаблицаШапка.Кратность КАК ЧИСЛО(15, 2)) КАК СуммаНСП
		|ПОМЕСТИТЬ ВременнаяТаблицаСтроки
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ПО (ИСТИНА)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаСтроки.ДокументСсылка,
		|	ВременнаяТаблицаСтроки.Организация,
		|	ВременнаяТаблицаСтроки.Контрагент,
		|	ВременнаяТаблицаСтроки.ДоговорКонтрагента,
		|	ВременнаяТаблицаСтроки.ДатаПоставки,
		|	ВременнаяТаблицаСтроки.СерияБланкаСФ,
		|	ВременнаяТаблицаСтроки.НомерБланкаСФ,
		|	ВременнаяТаблицаСтроки.ДатаСФ,
		|	ВременнаяТаблицаСтроки.ПризнакСтраны,
		|	-СУММА(ВременнаяТаблицаСтроки.Сумма) КАК Сумма,
		|	-СУММА(ВременнаяТаблицаСтроки.СуммаНДС) КАК СуммаНДС,
		|	-СУММА(ВременнаяТаблицаСтроки.СуммаНСП) КАК СуммаНСП
		|ИЗ
		|	ВременнаяТаблицаСтроки КАК ВременнаяТаблицаСтроки
		|ГДЕ
		|	ВременнаяТаблицаСтроки.ПризнакСтраны <> ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ИмпортЭкспорт)
		|   И ВременнаяТаблицаСтроки.СерияБланкаСФ <> """"
		|   И (ВременнаяТаблицаСтроки.Сумма <> 0
		|   ИЛИ ВременнаяТаблицаСтроки.СуммаНДС <> 0
		|   ИЛИ ВременнаяТаблицаСтроки.СуммаНСП <> 0)
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаСтроки.ДокументСсылка,
		|	ВременнаяТаблицаСтроки.Организация,
		|	ВременнаяТаблицаСтроки.Контрагент,
		|	ВременнаяТаблицаСтроки.ДоговорКонтрагента,
		|	ВременнаяТаблицаСтроки.ДатаПоставки,
		|	ВременнаяТаблицаСтроки.СерияБланкаСФ,
		|	ВременнаяТаблицаСтроки.НомерБланкаСФ,
		|	ВременнаяТаблицаСтроки.ДатаСФ,
		|	ВременнаяТаблицаСтроки.ПризнакСтраны";		
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСведенияОПоступлении", Запрос.Выполнить().Выгрузить());		
КонецПроцедуры 

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаРеестрПриобретенных(СтруктураДополнительныеСвойства) 
	                   
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Ссылка КАК Документ,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Контрагент КАК Контрагент,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.Контрагент.НаименованиеПолное = """"
		|			ТОГДА ВременнаяТаблицаШапка.Контрагент.Наименование
		|		ИНАЧЕ ВременнаяТаблицаШапка.Контрагент.НаименованиеПолное
		|	КОНЕЦ КАК КонтрагентНаименование,
		|	ВременнаяТаблицаШапка.Контрагент.ИНН КАК ИННКонтрагента,
		|	ВременнаяТаблицаШапка.Контрагент.ГНС.Код КАК КодГНСКонтрагента,
		|	ВременнаяТаблицаШапка.ДатаСФ КАК ДатаПоставки,
		|	ВременнаяТаблицаШапка.СерияБланкаСФ КАК СерияБланкаСФ,
		|	ВременнаяТаблицаШапка.НомерБланкаСФ КАК НомерБланкаСФ,
		|	ВременнаяТаблицаШапка.КорСерияБланкаСФ КАК КорСерияБланкаСФ,
		|	ВременнаяТаблицаШапка.КорНомерБланкаСФ КАК КорНомерБланкаСФ,
		|	-СУММА(ВременнаяТаблицаТовары.Сумма) КАК Сумма,
		|	-СУММА(ВременнаяТаблицаТовары.СуммаНДС) КАК СуммаНДС,
		|	-СУММА(ВЫБОР
		|			КОГДА &УказыватьПризнакЗачетаНДС
		|					ИЛИ ВременнаяТаблицаТовары.ЗачетНДС <> ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Себестоимость)
		|				ТОГДА ВременнаяТаблицаТовары.СуммаНДС
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК СуммаПодлежащаяКЗачетуНДС
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.КР)
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаШапка.ДатаСФ,
		|	ВЫБОР
		|		КОГДА ВременнаяТаблицаШапка.Контрагент.НаименованиеПолное = """"
		|			ТОГДА ВременнаяТаблицаШапка.Контрагент.Наименование
		|		ИНАЧЕ ВременнаяТаблицаШапка.Контрагент.НаименованиеПолное
		|	КОНЕЦ,
		|	ВременнаяТаблицаШапка.НомерБланкаСФ,
		|	ВременнаяТаблицаШапка.Ссылка,
		|	ВременнаяТаблицаШапка.Контрагент.ИНН,
		|	ВременнаяТаблицаШапка.СерияБланкаСФ,
		|	ВременнаяТаблицаШапка.КорСерияБланкаСФ,
		|	ВременнаяТаблицаШапка.КорНомерБланкаСФ,
		|	ВременнаяТаблицаШапка.Контрагент.ГНС.Код,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.Контрагент";		
	Запрос.УстановитьПараметр("УказыватьПризнакЗачетаНДС", СтруктураДополнительныеСвойства.УчетнаяПолитика.УказыватьПризнакЗачетаНДСПриПоступлении);
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеестрПриобретенных", Запрос.Выполнить().Выгрузить());		
КонецПроцедуры 

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаРеестрВвезенных(СтруктураДополнительныеСвойства) 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаШапка.Дата КАК Период,
		|	ВременнаяТаблицаШапка.Номер КАК Номер,
		|	ВременнаяТаблицаШапка.Организация КАК Организация,
		|	ВременнаяТаблицаШапка.Контрагент КАК Контрагент,
		|	-СУММА(ВременнаяТаблицаТовары.СуммаНДС) КАК СуммаНДС,
		|	-СУММА(ВЫБОР
		|			КОГДА &УказыватьПризнакЗачетаНДС
		|					ИЛИ ВременнаяТаблицаТовары.ЗачетНДС <> ЗНАЧЕНИЕ(Перечисление.ВидыЗачетаНДС.Себестоимость)
		|				ТОГДА ВременнаяТаблицаТовары.СуммаНДС
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК СуммаПодлежащаяКЗачетуНДС
		|ИЗ
		|	ВременнаяТаблицаШапка КАК ВременнаяТаблицаШапка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ПО (ИСТИНА)
		|ГДЕ
		|	ВременнаяТаблицаШапка.ПризнакСтраны = ЗНАЧЕНИЕ(Перечисление.ПризнакиСтраны.ЕАЭС)
		|	И ВременнаяТаблицаТовары.СуммаНДС <> 0
		|
		|СГРУППИРОВАТЬ ПО
		|	ВременнаяТаблицаШапка.Дата,
		|	ВременнаяТаблицаШапка.Номер,
		|	ВременнаяТаблицаШапка.Организация,
		|	ВременнаяТаблицаШапка.Контрагент";		
	Запрос.УстановитьПараметр("УказыватьПризнакЗачетаНДС", СтруктураДополнительныеСвойства.УчетнаяПолитика.УказыватьПризнакЗачетаНДСПриПоступлении);
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРеестрВвезенных", Запрос.Выполнить().Выгрузить());		
КонецПроцедуры

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства, Отказ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц 	= СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВозвратТоваровПоставщику.Ссылка,
		|	ВозвратТоваровПоставщику.Организация,
		|	ВозвратТоваровПоставщику.Дата,
		|	ВозвратТоваровПоставщику.Номер,
		|	ВозвратТоваровПоставщику.ВидОперации,
		|	ВозвратТоваровПоставщику.Контрагент,
		|	ВозвратТоваровПоставщику.ВалютаДокумента,
		|	ВозвратТоваровПоставщику.ДоговорКонтрагента,
		|	ВозвратТоваровПоставщику.Склад,
		|	ВозвратТоваровПоставщику.ЗначениеСтавкиНДС,
		|	ВозвратТоваровПоставщику.ЗначениеСтавкиНСП,
		|	ВозвратТоваровПоставщику.БезналичныйРасчет,
		|	ВозвратТоваровПоставщику.ДокументОснование,
		|	ВозвратТоваровПоставщику.Курс,
		|	ВозвратТоваровПоставщику.Кратность,
		|	ВозвратТоваровПоставщику.СчетРасчетов,
		|	ВозвратТоваровПоставщику.СерияБланкаСФ,
		|	ВозвратТоваровПоставщику.НомерБланкаСФ,
		|	ВозвратТоваровПоставщику.ДатаСФ,
		|	ВозвратТоваровПоставщику.ПризнакСтраны,
		|	ПоступлениеТоваровУслуг.СерияБланкаСФ КАК КорСерияБланкаСФ,
		|	ПоступлениеТоваровУслуг.НомерБланкаСФ КАК КорНомерБланкаСФ
		|ПОМЕСТИТЬ ВременнаяТаблицаШапка
		|ИЗ
		|	Документ.ВозвратТоваровПоставщику КАК ВозвратТоваровПоставщику
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
		|		ПО ВозвратТоваровПоставщику.ДокументОснование = ПоступлениеТоваровУслуг.Ссылка
		|ГДЕ
		|	ВозвратТоваровПоставщику.Ссылка = &ДокументСсылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВозвратТоваровПоставщикуТовары.НомерСтроки,
		|	ВозвратТоваровПоставщикуТовары.Номенклатура,
		|	ВозвратТоваровПоставщикуТовары.Количество,
		|	ВозвратТоваровПоставщикуТовары.Сумма,
		|	ВозвратТоваровПоставщикуТовары.СуммаНДС,
		|	ВозвратТоваровПоставщикуТовары.СуммаНСП,
		|	ВозвратТоваровПоставщикуТовары.СчетУчета,
		|	ВозвратТоваровПоставщикуТовары.Всего,
		|	ВозвратТоваровПоставщикуТовары.ЗачетНДС
		|ПОМЕСТИТЬ ВременнаяТаблицаТовары
		|ИЗ
		|	Документ.ВозвратТоваровПоставщику.Товары КАК ВозвратТоваровПоставщикуТовары
		|ГДЕ
		|	ВозвратТоваровПоставщикуТовары.Ссылка = &ДокументСсылка";	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	Запрос.Выполнить();    		
		
	СформироватьТаблицаХозрасчетный(ДокументСсылка, СтруктураДополнительныеСвойства, Отказ);	
	СформироватьТаблицаПоступлениеТоваров(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаСведенияОПоступлении(СтруктураДополнительныеСвойства);
	СформироватьТаблицаРеестрПриобретенных(СтруктураДополнительныеСвойства);
	СформироватьТаблицаРеестрВвезенных(СтруктураДополнительныеСвойства);
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

// Функция формирует табличный документ с печатной формой ПечатьНакладной
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьНакладной(МассивОбъектов, ОбъектыПечати)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ВозвратТоваровПоставщику.Ссылка,
		|	ВозвратТоваровПоставщику.Номер,
		|	ВозвратТоваровПоставщику.Дата,
		|	ВозвратТоваровПоставщику.Организация,
		|	ВозвратТоваровПоставщику.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	ВозвратТоваровПоставщику.ВалютаДокумента,
		|	ВозвратТоваровПоставщику.Контрагент,
		|	ВозвратТоваровПоставщику.Контрагент.НаименованиеПолное КАК КонтрагентНаименованиеПолное,
		|	ВозвратТоваровПоставщику.Склад,
		|	ПРЕДСТАВЛЕНИЕ(ВозвратТоваровПоставщику.Склад) КАК СкладПредставление,
		|	ВозвратТоваровПоставщику.Товары.(
		|		НомерСтроки,
		|		Номенклатура,
		|		Номенклатура.НаименованиеПолное КАК НоменклатураНаименованиеПолное,
		|		ПРЕДСТАВЛЕНИЕ(ВозвратТоваровПоставщику.Товары.Номенклатура.ЕдиницаИзмерения) КАК ЕИ,
		|		Количество,
		|		Цена,
		|		Сумма,
		|		СуммаНДС,
		|		СуммаНСП
		|	)
		|ИЗ
		|	Документ.ВозвратТоваровПоставщику КАК ВозвратТоваровПоставщику
		|ГДЕ
		|	ВозвратТоваровПоставщику.Ссылка В(&СписокДокументов)";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ВозвратТоваровПоставщику_Накладная";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ВозвратТоваровПоставщику.ПФ_MXL_Накладная");
	
	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подготовка данных
		ДанныеПечати = Новый Структура;
		
		ТекстЗаголовка = СформироватьЗаголовокДокумента(Шапка, НСтр("ru = 'Накладная на возврат поставщику'"));
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ДанныеПечати.Вставить("ОрганизацияНаименованиеПолное", Шапка.ОрганизацияНаименованиеПолное);
		ДанныеПечати.Вставить("СкладПредставление", Шапка.СкладПредставление);
		ДанныеПечати.Вставить("КонтрагентНаименованиеПолное", Шапка.КонтрагентНаименованиеПолное);
		
		ТаблицаТовары = Шапка.Товары.Выгрузить();

		Всего = ТаблицаТовары.Итог("Сумма");
		ВсегоНДС = ТаблицаТовары.Итог("СуммаНДС");
		ВсегоНСП = ТаблицаТовары.Итог("СуммаНСП");
		КоличествоНаименований = ТаблицаТовары.Количество();		
		
		ДанныеПечати.Вставить("Всего", Всего);
		ДанныеПечати.Вставить("ВсегоНДС", ВсегоНДС);
		ДанныеПечати.Вставить("ВсегоНСП", ВсегоНСП);
		ДанныеПечати.Вставить("ИтоговаяСтрока", 
			СтрШаблон(НСтр("ru = 'Всего наименований %1, на сумму %2'"), 
			Формат(КоличествоНаименований, "ЧН=0; ЧГ=0"), Формат(ДанныеПечати.Всего, "ЧЦ=15; ЧДЦ=2")));
		ДанныеПечати.Вставить("СуммаПрописью", БухгалтерскийУчетСервер.СформироватьСуммуПрописью(ДанныеПечати.Всего, Шапка.ВалютаДокумента));

		// Области
		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Заголовок");
		МассивОбластейМакета.Добавить("ШапкаТаблицы");
		МассивОбластейМакета.Добавить("Строка");
		МассивОбластейМакета.Добавить("Подвал");
		МассивОбластейМакета.Добавить("Итоги");
		МассивОбластейМакета.Добавить("ИтогиНДС");
		МассивОбластейМакета.Добавить("ИтогиНСП");
		МассивОбластейМакета.Добавить("СуммаПрописью");
		МассивОбластейМакета.Добавить("Подписи");

		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			Если ИмяОбласти <> "Строка" Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			ИначеЕсли ИмяОбласти = "Строка" Тогда 
				Для Каждого СтрокаТаблицы Из ТаблицаТовары Цикл
					ОбластьМакета.Параметры.Заполнить(СтрокаТаблицы);
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
			КонецЕсли;	
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Накладная") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"Накладная", НСтр("ru = 'Накладная'"), ПечатьНакладной(МассивОбъектов, ОбъектыПечати),,
			"Документ.ВозвратТоваровПоставщику.ПФ_MXL_Накладная");
	КонецЕсли;
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Накладная";
	КомандаПечати.Представление = НСтр("ru = 'Накладная'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "РеестрВозвратТоваровПоставщику";
	КомандаПечати.Представление  = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Реестр документов ""Возврат товаров поставщику""'");
	КомандаПечати.Обработчик     = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает заголовок документа для печатной формы.
//
// Параметры:
//  Шапка - любая структура с полями:
//           Номер         - Строка или Число - номер документа;
//           Дата          - Дата - дата документа;
//           Представление - Строка - (необязательный) платформенное представление ссылки на документ.
//                                    Если параметр НазваниеДокумента не задан, то название документа будет вычисляться
//                                    из этого параметра.
//  НазваниеДокумента - Строка - название документа (например, "Счет на оплату").
//
// Возвращаемое значение:
//  Строка - заголовок документа.
//
Функция СформироватьЗаголовокДокумента(Шапка, Знач НазваниеДокумента = "")
	
	ДанныеДокумента = Новый Структура("Номер,Дата,Представление");
	ЗаполнитьЗначенияСвойств(ДанныеДокумента, Шапка);
	
	// Если название документа не передано, получим название по представлению документа.
	Если ПустаяСтрока(НазваниеДокумента) И ЗначениеЗаполнено(ДанныеДокумента.Представление) Тогда
		ПоложениеНомера = СтрНайти(ДанныеДокумента.Представление, ДанныеДокумента.Номер);
		Если ПоложениеНомера > 0 Тогда
			НазваниеДокумента = СокрЛП(Лев(ДанныеДокумента.Представление, ПоложениеНомера - 1));
		КонецЕсли;
	КонецЕсли;

	НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокумента.Номер);
	Возврат СтрШаблон(НСтр("ru = '%1 № %2 от %3'"),
		НазваниеДокумента, НомерНаПечать, Формат(ДанныеДокумента.Дата, "ДЛФ=DD"));
	
КонецФункции

#КонецОбласти

#КонецЕсли