﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДокумент() Экспорт
	
	ЗаполнитьПриложение1();
	ЗаполнитьПриложение2();
	ЗаполнитьПриложение2_1();
	ЗаполнитьПриложение3();
	ЗаполнитьПриложение4();
	ЗаполнитьПриложение6();
	ЗаполнитьПриложение6_1();
	ЗаполнитьПриложение8();
	ЗаполнитьПриложение9();
	ЗаполнитьОсновнаяФорма();	
	
	Модифицированность = Истина;
КонецПроцедуры

Процедура ЗаполнитьПриложение1()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ТаблицаПоказателиИмпорта.Ссылка = ЗНАЧЕНИЕ(Перечисление.ПоказателиИмпорта.ПредметыЛизинга)
		|			ТОГДА ""150""
		|		КОГДА ТаблицаПоказателиИмпорта.Ссылка = ЗНАЧЕНИЕ(Перечисление.ПоказателиИмпорта.ПродуктыПереработкиДС)
		|			ТОГДА ""151""
		|		КОГДА ТаблицаПоказателиИмпорта.Ссылка = ЗНАЧЕНИЕ(Перечисление.ПоказателиИмпорта.ТранспортныеСредства)
		|			ТОГДА ""152""
		|		КОГДА ТаблицаПоказателиИмпорта.Ссылка = ЗНАЧЕНИЕ(Перечисление.ПоказателиИмпорта.Прочее)
		|			ТОГДА ""153""
		|	КОНЕЦ КАК НомерГрафыОтчета,
		|	ТаблицаПоказателиИмпорта.Ссылка КАК Содержание,
		|	СУММА(НДСНаИмпортОбороты.СуммаОборот) КАК Сумма,
		|	СУММА(НДСНаИмпортОбороты.СуммаНДСОборот) КАК СуммаНДС
		|ИЗ
		|	Перечисление.ПоказателиИмпорта КАК ТаблицаПоказателиИмпорта
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.НДСНаИмпорт.Обороты(&НачалоПериода, &КонецПериода, , Организация = &Организация) КАК НДСНаИмпортОбороты
		|		ПО ТаблицаПоказателиИмпорта.Ссылка = НДСНаИмпортОбороты.ПоказательИмпорта
		|
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР
		|		КОГДА ТаблицаПоказателиИмпорта.Ссылка = ЗНАЧЕНИЕ(Перечисление.ПоказателиИмпорта.ПредметыЛизинга)
		|			ТОГДА ""150""
		|		КОГДА ТаблицаПоказателиИмпорта.Ссылка = ЗНАЧЕНИЕ(Перечисление.ПоказателиИмпорта.ПродуктыПереработкиДС)
		|			ТОГДА ""151""
		|		КОГДА ТаблицаПоказателиИмпорта.Ссылка = ЗНАЧЕНИЕ(Перечисление.ПоказателиИмпорта.ТранспортныеСредства)
		|			ТОГДА ""152""
		|		КОГДА ТаблицаПоказателиИмпорта.Ссылка = ЗНАЧЕНИЕ(Перечисление.ПоказателиИмпорта.Прочее)
		|			ТОГДА ""153""
		|	КОНЕЦ,
		|	ТаблицаПоказателиИмпорта.Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерГрафыОтчета";		
	Запрос.УстановитьПараметр("НачалоПериода", 			НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецПериода", 			КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Организация", 			Организация);	
	
	Приложение1.Загрузить(Запрос.Выполнить().Выгрузить());
	
	СтрокаТабличнойЧасти = Приложение1.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета 	= "154";
	СтрокаТабличнойЧасти.Содержание			= НСтр("ru = 'Итого облагаемый импорт (=150+151+152+153)'");
	СтрокаТабличнойЧасти.Сумма 				= Приложение1.Итог("Сумма");
	СтрокаТабличнойЧасти.СуммаНДС 			= Приложение1.Итог("СуммаНДС");
КонецПроцедуры

Процедура ЗаполнитьПриложение2()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СведенияОВвозимыхТоварах.КодСтраны КАК КодСтраны,
		|	СведенияОВвозимыхТоварах.НомерДокумента КАК НомерЗаявления,
		|	СведенияОВвозимыхТоварах.Дата КАК ДатаЗаявления,
		|	СУММА(СведенияОВвозимыхТоварах.СуммаАкциза) КАК СуммаАкцизногоНалога,
		|	СУММА(СведенияОВвозимыхТоварах.СуммаНДС) КАК СуммаНДС,
		|	СУММА(СведенияОВвозимыхТоварах.СуммаНДСЗачет) КАК СуммаНДСЗачет,
		|	СУММА(СведенияОВвозимыхТоварах.Стоимость) КАК СтоимостьТовара
		|ИЗ
		|	РегистрСведений.СведенияОВвозимыхТоварах КАК СведенияОВвозимыхТоварах
		|ГДЕ
		|	СведенияОВвозимыхТоварах.Организация = &Организация
		|	И СведенияОВвозимыхТоварах.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|
		|СГРУППИРОВАТЬ ПО
		|	СведенияОВвозимыхТоварах.КодСтраны,
		|	СведенияОВвозимыхТоварах.НомерДокумента,
		|	СведенияОВвозимыхТоварах.Дата";
	Запрос.УстановитьПараметр("Организация", 	Организация);
	Запрос.УстановитьПараметр("ДатаНачала", 	НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("ДатаОкончания", 	КонецМесяца(Дата));
	
	Приложение2.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры

Процедура ЗаполнитьПриложение2_1()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СведенияОВвозимыхТоварах.Номенклатура КАК Номенклатура,
		|	СведенияОВвозимыхТоварах.КодТНВЭД КАК КодТНВЭДЕАЕС,
		|	СведенияОВвозимыхТоварах.НомерСтрокиВДокументе КАК НомерСтрокиВЗаявлении,
		|	СведенияОВвозимыхТоварах.НомерДокумента КАК НомерЗаявленияОВвозе,
		|	СведенияОВвозимыхТоварах.Дата КАК ДатаЗаявленияОВвозеТоваров,
		|	СведенияОВвозимыхТоварах.Цена КАК ЦенаЗаЕдТовараПоДоговору,
		|	СведенияОВвозимыхТоварах.Количество КАК КоличествоИмпортированногоТовара
		|ИЗ
		|	РегистрСведений.СведенияОВвозимыхТоварах КАК СведенияОВвозимыхТоварах
		|ГДЕ
		|	СведенияОВвозимыхТоварах.Организация = &Организация
		|	И СведенияОВвозимыхТоварах.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания";
	Запрос.УстановитьПараметр("Организация", 	Организация);
	Запрос.УстановитьПараметр("ДатаНачала", 	НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("ДатаОкончания", 	КонецМесяца(Дата));
	
	Приложение2_1.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры

Процедура ЗаполнитьПриложение3()
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.ГумПомощь)
		|			ТОГДА ""350""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.Диппредставительства)
		|			ТОГДА ""351""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.ПриродныйГаз)
		|			ТОГДА ""352""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.ЛекарственныеСредства)
		|			ТОГДА ""353""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.СпецтоварыСтекловарения)
		|			ТОГДА ""354""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.СельскоеХозяйство)
		|			ТОГДА ""355""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.ВоенноеНазначение)
		|			ТОГДА ""356""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.Электроэнергия)
		|			ТОГДА ""357""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.БанковскоеОборудование)
		|			ТОГДА ""358""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.Зерно)
		|			ТОГДА ""359""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.РеактивноеТопливо)
		|			ТОГДА ""360""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.СоцЗначимыеТовары)
		|			ТОГДА ""361""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.Прочее)
		|			ТОГДА ""398""
		|	КОНЕЦ КАК НомерГрафыОтчета,
		|	ТаблицаИмпорт.Ссылка КАК Содержание,
		|	СУММА(НДСНаИмпортОбороты.СуммаОборот) КАК Сумма
		|ИЗ
		|	Перечисление.ИмпортОсвобожденныйОтНДС КАК ТаблицаИмпорт
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.НДСНаИмпорт.Обороты(&НачалоПериода, &КонецПериода, , Организация = &Организация) КАК НДСНаИмпортОбороты
		|		ПО ТаблицаИмпорт.Ссылка = НДСНаИмпортОбороты.ИмпортОсвобожденныйОтНДС
		|
		|СГРУППИРОВАТЬ ПО
		|	ВЫБОР
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.ГумПомощь)
		|			ТОГДА ""350""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.Диппредставительства)
		|			ТОГДА ""351""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.ПриродныйГаз)
		|			ТОГДА ""352""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.ЛекарственныеСредства)
		|			ТОГДА ""353""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.СпецтоварыСтекловарения)
		|			ТОГДА ""354""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.СельскоеХозяйство)
		|			ТОГДА ""355""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.ВоенноеНазначение)
		|			ТОГДА ""356""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.Электроэнергия)
		|			ТОГДА ""357""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.БанковскоеОборудование)
		|			ТОГДА ""358""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.Зерно)
		|			ТОГДА ""359""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.РеактивноеТопливо)
		|			ТОГДА ""360""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.СоцЗначимыеТовары)
		|			ТОГДА ""361""
		|		КОГДА ТаблицаИмпорт.Ссылка = ЗНАЧЕНИЕ(Перечисление.ИмпортОсвобожденныйОтНДС.Прочее)
		|			ТОГДА ""398""
		|	КОНЕЦ,
		|	ТаблицаИмпорт.Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерГрафыОтчета";		
	Запрос.УстановитьПараметр("НачалоПериода", 	НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецПериода", 	КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Организация", 	Организация);	

	Приложение3.Загрузить(Запрос.Выполнить().Выгрузить());
	
	СтрокаТабличнойЧасти = Приложение3.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "399";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Итого импорт товаров, предусмотренных Налоговым кодексом Кыргызской Республики  и международными договорами (= сумма показателей строк с 350 по 398)'");
	СтрокаТабличнойЧасти.Сумма = Приложение3.Итог("Сумма");
	
	СтрокаТабличнойЧасти = Приложение3.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "350";
	СтрокаТабличнойЧасти.Содержание = Перечисления.ИмпортОсвобожденныйОтНДС.Гумпомощь;
	
	СтрокаТабличнойЧасти = Приложение3.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "351";
	СтрокаТабличнойЧасти.Содержание = Перечисления.ИмпортОсвобожденныйОтНДС.Диппредставительства;
	
	СтрокаТабличнойЧасти = Приложение3.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "352";
	СтрокаТабличнойЧасти.Содержание = Перечисления.ИмпортОсвобожденныйОтНДС.ПриродныйГаз;
	
	СтрокаТабличнойЧасти = Приложение3.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "353";
	СтрокаТабличнойЧасти.Содержание = Перечисления.ИмпортОсвобожденныйОтНДС.ЛекарственныеСредства;
	
	СтрокаТабличнойЧасти = Приложение3.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "354";
	СтрокаТабличнойЧасти.Содержание = Перечисления.ИмпортОсвобожденныйОтНДС.СпецтоварыСтекловарения;
	
	СтрокаТабличнойЧасти = Приложение3.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "355";
	СтрокаТабличнойЧасти.Содержание = Перечисления.ИмпортОсвобожденныйОтНДС.СельскоеХозяйство;
	
	СтрокаТабличнойЧасти = Приложение3.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "356";
	СтрокаТабличнойЧасти.Содержание = Перечисления.ИмпортОсвобожденныйОтНДС.ВоенноеНазначение;
	
	СтрокаТабличнойЧасти = Приложение3.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "357";
	СтрокаТабличнойЧасти.Содержание = Перечисления.ИмпортОсвобожденныйОтНДС.Электроэнергия;
	
	СтрокаТабличнойЧасти = Приложение3.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "358";
	СтрокаТабличнойЧасти.Содержание = Перечисления.ИмпортОсвобожденныйОтНДС.БанковскоеОборудование;
	
	СтрокаТабличнойЧасти = Приложение3.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "359";
	СтрокаТабличнойЧасти.Содержание = Перечисления.ИмпортОсвобожденныйОтНДС.Зерно;
	
	СтрокаТабличнойЧасти = Приложение3.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "360";
	СтрокаТабличнойЧасти.Содержание = Перечисления.ИмпортОсвобожденныйОтНДС.РеактивноеТопливо;
	
	СтрокаТабличнойЧасти = Приложение3.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "361";
	СтрокаТабличнойЧасти.Содержание = Перечисления.ИмпортОсвобожденныйОтНДС.СоцЗначимыеТовары;
	
	СтрокаТабличнойЧасти = Приложение3.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "398";
	СтрокаТабличнойЧасти.Содержание = Перечисления.ИмпортОсвобожденныйОтНДС.Прочее;
	
	СтрокаТабличнойЧасти = Приложение3.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "399";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Итого импорт товаров, предусмотренных Налоговым кодексом Кыргызской Республики  и международными договорами (= сумма показателей строк с 350 по 398)'");
КонецПроцедуры

Процедура ЗаполнитьПриложение4()

	СтрокаТабличнойЧасти = Приложение4.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "401";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Спирт, алкогольные и спиртосодержащие товары'");	

	СтрокаТабличнойЧасти = Приложение4.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "402";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Табачная продукция'");
	
	СтрокаТабличнойЧасти = Приложение4.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "403";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Масла и газовый конденсат'");
	
	СтрокаТабличнойЧасти = Приложение4.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "404";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Бензин, легкие и средние дистилляты и прочие бензины'");
	
	СтрокаТабличнойЧасти = Приложение4.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "405";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Дизельное топливо'");
	
	СтрокаТабличнойЧасти = Приложение4.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "406";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Топливо реактивное'");
	
	СтрокаТабличнойЧасти = Приложение4.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "407";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Мазут'");
	
	СтрокаТабличнойЧасти = Приложение4.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "408";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Нефть сырая и нефтепродукты сырые, полученные из битуминозных материалов'");
	
	СтрокаТабличнойЧасти = Приложение4.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "409";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Итого:'");
	
	СтрокаТабличнойЧасти = Приложение4.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "410";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Сумма акцизного налога, внесенная на специальный счет налогового органа (депозит)'");
	
	СтрокаТабличнойЧасти = Приложение4.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "411";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Сумма депозита, не подтвержденная документально'");
	
	СтрокаТабличнойЧасти = Приложение4.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "412";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Сумма депозита, подлежащая возврату налогоплательщику'");
КонецПроцедуры

Процедура ЗаполнитьПриложение6()

	СтрокаТабличнойЧасти = Приложение6.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "601";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Сигареты с фильтром'");	

	СтрокаТабличнойЧасти = Приложение6.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "602";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Сигареты без фильтра'");
	
	СтрокаТабличнойЧасти = Приложение6.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "603";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Сигары'");
	
	СтрокаТабличнойЧасти = Приложение6.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "604";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Сигариллы'");
	
	СтрокаТабличнойЧасти = Приложение6.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "605";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Прочие изделия содержащие табак кроме табака ферментированно'");
	
	СтрокаТабличнойЧасти = Приложение6.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "606";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Итого'");
КонецПроцедуры

Процедура ЗаполнитьПриложение6_1()

	Для НомерГрафы = 601 По 620 Цикл 
		СтрокаТабличнойЧасти = Приложение6_1.Добавить();
		СтрокаТабличнойЧасти.НомерГрафыОтчета = НомерГрафы;
		СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Сигареты (с фильтром / без фильтра в 1000 шт.)'");	
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьПриложение8()

	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	СведенияОПодакцизныхТоварах.ДатаУведомления КАК ДатаУведомления,
	//	|	СведенияОПодакцизныхТоварах.НомерУведомления КАК НомерУведомления,
	//	|	СведенияОПодакцизныхТоварах.ДатаФактическогоВвоза КАК ДатаФактическогоВвоза,
	//	|	СведенияОПодакцизныхТоварах.КодСтраны КАК КодСтраны,
	//	|	СведенияОПодакцизныхТоварах.ЕдиницаИзмерения КАК ЕдИзмер,
	//	|	СведенияОПодакцизныхТоварах.ОблагаемыйОбъем КАК ОблагаемыйОбъем
	//	|ИЗ
	//	|	РегистрСведений.СведенияОПодакцизныхТоварах КАК СведенияОПодакцизныхТоварах
	//	|ГДЕ
	//	|	СведенияОПодакцизныхТоварах.Организация = &Организация
	//	|	И СведенияОПодакцизныхТоварах.ДатаУведомления МЕЖДУ &ДатаНачала И &ДатаОкончания";
	//
	//Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(Дата));
	//Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(Дата));
	//Запрос.УстановитьПараметр("Организация", Организация);
	//
	//Приложение8.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры

Процедура ЗаполнитьПриложение9()

	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "901";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Спирт, алкогольные и спиртосодержащие товары'");
	СтрокаТабличнойЧасти.КодТНВЭД = "2203 - 2208";

	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "902";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Табачная продукция'");
	СтрокаТабличнойЧасти.КодТНВЭД = "2402";
	
	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "903";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Масла и газовый конденсат'");
	СтрокаТабличнойЧасти.КодТНВЭД = "2709001001,2709001009,2710197100-2710199800";
	
	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "904";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Бензин, легкие и средние дистилляты и прочие бензин'");
	СтрокаТабличнойЧасти.КодТНВЭД = "2710121100-2710129009, 2710191100-2710191500, 2710192500-2710192900";
	
	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "905";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Дизельное топливо'");
	СтрокаТабличнойЧасти.КодТНВЭД = "2710193100-2710194800, 2710201100-2710201900";
	
	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "906";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Топливо реактивное'");
	СтрокаТабличнойЧасти.КодТНВЭД = "2710192100";
	
	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "907";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Мазут'");
	СтрокаТабличнойЧасти.КодТНВЭД = "2710195100-2710196809, 2710203101-2710203909";
	
	СтрокаТабличнойЧасти = Приложение9.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета = "908";
	СтрокаТабличнойЧасти.Содержание = НСтр("ru = 'Нефть сырая и нефтепродукты сырые, полученные из битуминозных материалов'");
	СтрокаТабличнойЧасти.КодТНВЭД = "2709009001-2709009009";
КонецПроцедуры

Процедура ЗаполнитьОсновнаяФорма()
	
	// Заполнение "050" и "051".
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("НомерГрафыОтчета", "154");	
	МассивСтрок = Приложение1.НайтиСтроки(ПараметрыОтбора);
	
	СтрокаТабличнойЧасти = ОсновнаяФорма.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета 	= "050";                       	
	СтрокаТабличнойЧасти.Содержание		 	= НСтр("ru = 'Стоимость облагаемого импорта'");
	СтрокаТабличнойЧасти.Сумма = ?(МассивСтрок.Количество() > 0, МассивСтрок[0].Сумма, 0);

	СтрокаТабличнойЧасти = ОсновнаяФорма.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета 	= "051";
	СтрокаТабличнойЧасти.Содержание		 	= НСтр("ru = 'Сумма НДС на импорт'");
	СтрокаТабличнойЧасти.Сумма = ?(МассивСтрок.Количество() > 0, МассивСтрок[0].СуммаНДС, 0);
	
	// Заполнение "052".
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("НомерГрафыОтчета", "399");	
	МассивСтрок = Приложение3.НайтиСтроки(ПараметрыОтбора);
	
	СтрокаТабличнойЧасти = ОсновнаяФорма.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета 	= "052";
	СтрокаТабличнойЧасти.Содержание		 	= НСтр("ru = 'Стоимость импорта, освобожденного от НДС'");
	СтрокаТабличнойЧасти.Сумма = ?(МассивСтрок.Количество() > 0, МассивСтрок[0].Сумма, 0);
	
	// Заполнение "053".
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("НомерГрафыОтчета", "409");	
	МассивСтрок = Приложение4.НайтиСтроки(ПараметрыОтбора);
	
	СтрокаТабличнойЧасти = ОсновнаяФорма.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета 	= "053";
	СтрокаТабличнойЧасти.Содержание		 	= НСтр("ru = 'Сумма акциза на импорт'");
	СтрокаТабличнойЧасти.Сумма = ?(МассивСтрок.Количество() > 0, МассивСтрок[0].СуммаАкциза, 0);
	
	// Заполнение "054".
	Сумма = Приложение9.Итог("СтоимостьИмпортированныхПодакцизныхТоваров");
	
	СтрокаТабличнойЧасти = ОсновнаяФорма.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета 	= "054";
	СтрокаТабличнойЧасти.Содержание		 	= НСтр("ru = 'Стоимость импорта, подакцизных товаров, освобожденных от акциза'");
	СтрокаТабличнойЧасти.Сумма = Сумма;
	
	СтрокаТабличнойЧасти = ОсновнаяФорма.Добавить();
	СтрокаТабличнойЧасти.НомерГрафыОтчета 	= "055";
	СтрокаТабличнойЧасти.Содержание		 	= НСтр("ru = 'Документы, прилагаемые к отчету'");
	СтрокаТабличнойЧасти.Сумма = 0;
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли