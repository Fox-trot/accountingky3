﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("СтруктураДанных") Тогда
		Если Параметры.СтруктураДанных.Свойство("ГруппаНУ") Тогда
		 	Объект.ГруппаНУ = Параметры.СтруктураДанных.ГруппаНУ;
		КонецЕсли;
		
		Если Параметры.СтруктураДанных.Свойство("ОсновноеСредство") Тогда
		 	Объект.ОсновноеСредство = Параметры.СтруктураДанных.ОсновноеСредство;
		КонецЕсли;	
		
		Если Параметры.СтруктураДанных.Свойство("Организация") Тогда
		 	Объект.Организация = Параметры.СтруктураДанных.Организация;
		Иначе
			Объект.Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");		
		КонецЕсли;
		
		Если Параметры.СтруктураДанных.Свойство("Дата") Тогда
		 	Объект.Дата = Параметры.СтруктураДанных.Дата;
		Иначе
			Объект.Дата = НачалоГода(ТекущаяДата());
		КонецЕсли;
		
		Если Параметры.СтруктураДанных.Свойство("ИмяТабличнойЧасти") И Параметры.СтруктураДанных.ИмяТабличнойЧасти = "НалоговаяВыверка" Тогда
		 	ИмяАктивнойЗакладки = "НалоговаяВыверка";
		Иначе
			ИмяАктивнойЗакладки = "НалоговаяАмортизация";	
		КонецЕсли;		
	
	Иначе
		Объект.Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
		Объект.Дата = НачалоГода(ТекущаяДата());
	    ИмяАктивнойЗакладки = "НалоговаяАмортизация";
	КонецЕсли;

	ДанныеУчетнойПолитики = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиОрганизаций(Объект.Дата, Объект.Организация);
	ПараметрыДокументаЗакрытиеМесяца = ПараметрыДокументаЗакрытиеМесяца(Объект.Дата);	
	
	ЗаполнитьТабличныеЧастиНалоговойАмортизации();
	ЗаполнитьТабличныеЧастиПоНалоговойВыверке();
	
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ДанныеУчетнойПолитики = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиОрганизаций(Объект.Дата, Объект.Организация);
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ДанныеУчетнойПолитики = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиОрганизаций(Объект.Дата, Объект.Организация);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьТабличныеЧасти(Команда)
	ПараметрыДокументаЗакрытиеМесяца = ПараметрыДокументаЗакрытиеМесяца(Объект.Дата);	
	ЗаполнитьТабличныеЧастиНалоговойАмортизации();
	ЗаполнитьТабличныеЧастиПоНалоговойВыверке();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	Если ИмяАктивнойЗакладки = "НалоговаяВыверка" Тогда
	 	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаНалоговаяВыверкаГлавная;
	Иначе
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаНалоговаяАмортизация;	
	КонецЕсли;
	
КонецПроцедуры

// Процедура - рассчитать налоговую амортизацию в мониторе.
//
&НаСервере
Процедура ЗаполнитьТабличныеЧастиНалоговойАмортизации()
	// Суммы поступления и выбытия
	ТекстЗапроса = РасчетНалогаНаПрибыльСервер.ТекстЗапросаПоРасчетуНалоговойАмортизацииВМонитореНП();
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("Организация", 		Объект.Организация);
	Запрос.УстановитьПараметр("НачалоПрошлогоГода", НачалоГода(НачалоГода(Объект.Дата)-1));
	Запрос.УстановитьПараметр("НачалоГода", 		НачалоГода(Объект.Дата));
	Запрос.УстановитьПараметр("КонецГода", 			КонецГода(Объект.Дата));
	Запрос.УстановитьПараметр("ГруппаНУ", 			Объект.ГруппаНУ);
	Запрос.УстановитьПараметр("ОсновноеСредство", 	Объект.ОсновноеСредство);	
	
	МассивСчетовЗатратНаРемонтОС = Новый Массив();
	МассивСчетовЗатратНаРемонтОС.Добавить(ПланыСчетов.Хозрасчетный.ЗатратыНаРемонтИОбслуживаниеОсновныхСредств); // 7160
	МассивСчетовЗатратНаРемонтОС.Добавить(ПланыСчетов.Хозрасчетный.РемонтИОбслуживаниеОсновныхСредств); // 8110
	Запрос.УстановитьПараметр("СчетаЗатратНаРемонтОС",	МассивСчетовЗатратНаРемонтОС);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.СуммаПоступления <> 0 ИЛИ Выборка.СуммаПоступленияНУ <> 0 Тогда
			НоваяСтрока = Объект.НалоговаяАмортизацияПоступление.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);		
		ИначеЕсли Выборка.СуммаВыбытия <> 0 ИЛИ Выборка.СуммаВыбытияНУ <> 0 Тогда
			НоваяСтрока = Объект.НалоговаяАмортизацияПоступление.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		ИначеЕсли Выборка.ЗатратыНаРемонт <> 0 Тогда
			НоваяСтрока = Объект.НалоговаяАмортизацияЗатратыНаРемонт.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);		
		КонецЕсли;
			
	КонецЦикла;
	
	//// Затраты на ремонт
	//Если ПараметрыДокументаЗакрытиеМесяца.ЕстьДокументЗакрытиеМесяца Тогда
	//    ПредельнаяНормаНаРемонтОС = ПараметрыДокументаЗакрытиеМесяца.ПредельнаяНормаНаРемонтОС;
	//	
	//	ТекстЗапроса = РасчетНалогаНаПрибыльСервер.ТекстЗапроса_ЗатратыНаРемонт_МониторНП();	
	//	Запрос.Текст = ТекстЗапроса;
	//		
	//	РезультатЗапроса = Запрос.Выполнить();
	//	
	//	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	//		
	//		СтрокаТабличнойЧасти = Объект.ЗатратыНаРемонт.Добавить();
	//		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ВыборкаДетальныеЗаписи);
	//		
	//		БалансоваяСтоимостьНаНачалоГода = ВыборкаДетальныеЗаписи.БалансоваяСтоимостьНаКонецПрошлыйГод - ВыборкаДетальныеЗаписи.АмортизацияЗаПрошлыйГод;
	//		
	//		// Норма на ремонт 15%, если не укладываемся, то превышение идет на увеличение балансовой стоимости.
	//		Если НЕ ВыборкаДетальныеЗаписи.ЗатратыНаРемонт = 0 Тогда 
	//			СтрокаТабличнойЧасти.НормаНаРемонт = БалансоваяСтоимостьНаНачалоГода * ПредельнаяНормаНаРемонтОС / 100;	
	//		КонецЕсли;			
	//		
	//		// Превышение нормы на ремонт.
	//		Если ВыборкаДетальныеЗаписи.ЗатратыНаРемонт > СтрокаТабличнойЧасти.НормаНаРемонт Тогда 
	//			СтрокаТабличнойЧасти.ПревышениеНормыНаРемонт = ВыборкаДетальныеЗаписи.ЗатратыНаРемонт - СтрокаТабличнойЧасти.НормаНаРемонт;	
	//		КонецЕсли;
	//		
	//	КонецЦикла;
	//Иначе
	//	СтрокаСообщения = СтрШаблон(НСтр("ru = 'Нет проведенного документа ""Закрытие месяца"" на дату %1. Расшифровка по затратам на ремонт не может быть показана.'"), Формат(Объект.Дата, "ДФ=dd.MM.yyyy"));
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения)		
	//КонецЕсли;
	
КонецПроцедуры
	
&НаСервереБезКонтекста
Функция ПараметрыДокументаЗакрытиеМесяца(Дата)
	Параметры = Новый Структура("ЕстьДокументЗакрытиеМесяца, ссылка, ПредельнаяНормаНаРемонтОС", Ложь, Неопределено, 0);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИСТИНА КАК ЕстьДокументЗакрытиеМесяца,
		|	ЗакрытиеМесяца.Ссылка КАК Ссылка,
		|	ЗакрытиеМесяца.ПредельнаяНормаНаРемонтОС КАК ПредельнаяНормаНаРемонтОС
		|ИЗ
		|	Документ.ЗакрытиеМесяца КАК ЗакрытиеМесяца
		|ГДЕ
		|	ЗакрытиеМесяца.Дата = КОНЕЦПЕРИОДА(&Дата, ГОД)
		|	И ЗакрытиеМесяца.Проведен";
	
	Запрос.УстановитьПараметр("Дата", КонецГода(Дата));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Параметры, ВыборкаДетальныеЗаписи);
	КонецЕсли;

	Возврат Параметры; 	

КонецФункции // ЕстьДокументЗакрытиеМесяца()

// Процедура - рассчитать налоговую амортизацию в мониторе.
//
&НаСервере
Процедура ЗаполнитьТабличныеЧастиПоНалоговойВыверке()
	Если НЕ ПараметрыДокументаЗакрытиеМесяца.ЕстьДокументЗакрытиеМесяца Тогда
		СтрокаСообщения = СтрШаблон(НСтр("ru = 'Нет проведенного документа ""Закрытие месяца"" на дату %1. Расшифровка по налоговй выверке не может быть показана.'"), Формат(Объект.Дата, "ДФ=dd.MM.yyyy"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения);
		Возврат;
	КонецЕсли;
	ДокументЗакрытиеМесяца = ПараметрыДокументаЗакрытиеМесяца.Ссылка;
	
	СчетаУчетаИсключения = Новый Массив;
	СчетаУчетаИсключения.Добавить(ПланыСчетов.Хозрасчетный.РасходыНаАмортизациюОсновныхСредств);	
	
	// 1. Получение суммы доходов.
	// 2. Получение суммы раходов.
	// 3. Получение суммы постоянной разницы доходы.
	// 4. Получение суммы постоянной разницы расходы.
	// 5. Получение суммы амортизации ОС.
	// 6. Получение суммы временной разницы (расходы - доходы).
	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	1 КАК Порядок,
		|	-ХозрасчетныйОбороты.СуммаОборот КАК Сумма,
		|	ХозрасчетныйОбороты.Счет КАК Счет,
		|	ХозрасчетныйОбороты.Субконто1 КАК Субконто1,
		|	ХозрасчетныйОбороты.Регистратор КАК Документ
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Счет.Временный
		|				И Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный),
		|			,
		|			Организация = &Организация,
		|			НЕ КорСчет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.СводДоходовИРасходов),
		|			) КАК ХозрасчетныйОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	2 КАК Порядок,
		|	ХозрасчетныйОбороты.СуммаОборот КАК Сумма,
		|	ХозрасчетныйОбороты.Счет КАК Счет,
		|	ХозрасчетныйОбороты.Субконто1 КАК Субконто1,
		|	ХозрасчетныйОбороты.Регистратор КАК Документ
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Счет.Временный
		|				И Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный)
		|				И НЕ Счет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасходыДоходыПоНалогуНаПрибыль),
		|			,
		|			Организация = &Организация,
		|			НЕ КорСчет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.СводДоходовИРасходов),
		|			) КАК ХозрасчетныйОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	3 КАК Порядок,
		|	КорректировкиНУОбороты.СуммаОборот КАК Сумма,
		|	КорректировкиНУОбороты.Счет КАК Счет,
		|	КорректировкиНУОбороты.ВидУчета КАК ВидУчета,
		|	КорректировкиНУОбороты.Регистратор КАК Документ
		|ИЗ
		|	РегистрНакопления.КорректировкиНУ.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
		|				И ВидУчета = ЗНАЧЕНИЕ(Перечисление.ВидыУчета.ПР)) КАК КорректировкиНУОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	4 КАК Порядок,
		|	КорректировкиНУОбороты.СуммаОборот КАК Сумма,
		|	КорректировкиНУОбороты.Счет КАК Счет,
		|	КорректировкиНУОбороты.ВидУчета КАК ВидУчета,
		|	КорректировкиНУОбороты.Регистратор КАК Документ
		|ИЗ
		|	РегистрНакопления.КорректировкиНУ.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Активный)
		|				И ВидУчета = ЗНАЧЕНИЕ(Перечисление.ВидыУчета.ПР)) КАК КорректировкиНУОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	5 КАК Порядок,
		|	ХозрасчетныйОбороты.СуммаОборотКт КАК Сумма
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			,
		|			Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ОсновныеСредства))
		|				И Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный),
		|			,
		|			Организация = &Организация,
		|			,
		|			) КАК ХозрасчетныйОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	6 КАК Порядок,
		|	КорректировкиНУОбороты.ВидУчета КАК ВидУчета,
		|	СУММА(КорректировкиНУОбороты.СуммаОборот) КАК Сумма,
		|	КорректировкиНУОбороты.Регистратор КАК Документ,
		|	КорректировкиНУОбороты.Счет КАК Счет
		|ИЗ
		|	РегистрНакопления.КорректировкиНУ.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			Авто,
		|			Организация = &Организация
		|				И ВидУчета = ЗНАЧЕНИЕ(Перечисление.ВидыУчета.ВР)
		|				И НЕ Счет В (&СчетаУчетаИсключения)) КАК КорректировкиНУОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	КорректировкиНУОбороты.ВидУчета,
		|	КорректировкиНУОбороты.Счет,
		|	КорректировкиНУОбороты.Регистратор";
	Запрос.УстановитьПараметр("НачалоПериода", НачалоГода(Объект.Дата));
	Запрос.УстановитьПараметр("КонецПериода", КонецГода(Объект.Дата));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("СчетаУчетаИсключения", СчетаУчетаИсключения);

	МассивРезультатовЗапроса = Запрос.ВыполнитьПакет();
	
	Объект.НалоговаяВыверка01.Очистить();
	Объект.НалоговаяВыверка02.Очистить();
	Объект.НалоговаяВыверка04.Очистить();
	Объект.НалоговаяВыверка05.Очистить();
	Объект.НалоговаяВыверка10.Очистить();
	Объект.НалоговаяВыверка13.Очистить();
	
	// 1. Доходы по бухгалтерскому учету.
	СуммаДоходыБУ = 0;
	Если НЕ МассивРезультатовЗапроса[0].Пустой() Тогда 
		ВыборкаДетальныхЗаписей = МассивРезультатовЗапроса[0].Выбрать();
		Пока ВыборкаДетальныхЗаписей.Следующий() Цикл
			СтрокаНалоговойВыверки = Объект.НалоговаяВыверка01.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНалоговойВыверки, ВыборкаДетальныхЗаписей);
		КонецЦикла;
		
		СуммаДоходыБУ = Объект.НалоговаяВыверка01.Итог("Сумма");
	КонецЕсли;	
	
	// 2. Расходы по бухгалтерскому учету.
	СуммаРасходыБУ = 0;
	Если НЕ МассивРезультатовЗапроса[1].Пустой() Тогда 
		ВыборкаДетальныхЗаписей = МассивРезультатовЗапроса[1].Выбрать();
		Пока ВыборкаДетальныхЗаписей.Следующий() Цикл
			СтрокаНалоговойВыверки = Объект.НалоговаяВыверка02.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНалоговойВыверки, ВыборкаДетальныхЗаписей);
		КонецЦикла;
		
		СуммаДоходыБУ = Объект.НалоговаяВыверка02.Итог("Сумма");
	КонецЕсли;	
	
	// 3. Прибыль до налогобложения.
	СуммаПрибыльДоНалогов		= СуммаДоходыБУ - СуммаРасходыБУ;	
	
	// 4. Постоянные разницы - доходы.	
	СуммаПостоянныеРазницыДоходы = 0;
	Если НЕ МассивРезультатовЗапроса[2].Пустой() Тогда 
		ВыборкаДетальныхЗаписей = МассивРезультатовЗапроса[2].Выбрать();
		Пока ВыборкаДетальныхЗаписей.Следующий() Цикл
			СтрокаНалоговойВыверки = Объект.НалоговаяВыверка04.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНалоговойВыверки, ВыборкаДетальныхЗаписей);
		КонецЦикла;

		СуммаПостоянныеРазницыДоходы = Объект.НалоговаяВыверка04.Итог("Сумма");
	КонецЕсли;	
	
	// 5. Постоянные разницы - расходы.
	СуммаПостоянныеРазницыРасходы = 0;
	Если НЕ МассивРезультатовЗапроса[3].Пустой() Тогда 
		ВыборкаДетальныхЗаписей = МассивРезультатовЗапроса[3].Выбрать();
		Пока ВыборкаДетальныхЗаписей.Следующий() Цикл
			СтрокаНалоговойВыверки = Объект.НалоговаяВыверка05.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНалоговойВыверки, ВыборкаДетальныхЗаписей);
		КонецЦикла;
		
		СуммаПостоянныеРазницыРасходы = Объект.НалоговаяВыверка05.Итог("Сумма");
	КонецЕсли;

	// 6. Постоянные разницы.
	СуммаПостоянныеРазницы						= -(СуммаПостоянныеРазницыДоходы - СуммаПостоянныеРазницыРасходы);
	
	// 7. Прибыль с учетом постоянных разниц.
	СуммаПрибыльСУчетомПостоянныхРазниц			= СуммаПрибыльДоНалогов + СуммаПостоянныеРазницы;
	
	// 8. Расходы по налогу на прибыль (справочно).
	СтавкаНалогаНаПрибыль = СтавкаНалогаНаПрибыль;
	РасходыПоНалогуНаПрибыль = 0;
	Если СуммаПрибыльСУчетомПостоянныхРазниц > 0 Тогда 
		РасходыПоНалогуНаПрибыль			= Окр(СуммаПрибыльСУчетомПостоянныхРазниц * СтавкаНалогаНаПрибыль / 100,0);
	КонецЕсли;
	
	// 9. Временные разницы.
	
	// 10. Доход от выбытия ОС.		
	//СуммаДоходОтВыбытияОС = - ДокументЗакрытиеМесяца.НалоговаяАмортизация.Итог("УвеличениеСОД");
	Для каждого СтрокаТаблицыНА Из ДокументЗакрытиеМесяца.НалоговаяАмортизация Цикл
		Если СтрокаТаблицыНА.УвеличениеСОД > 0 Тогда
		 	СтрокаТабличнойЧасти = Объект.НалоговаяВыверка10.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТаблицыНА);
		    СтрокаТабличнойЧасти.Сумма = СтрокаТаблицыНА.УвеличениеСОД;
		КонецЕсли;
		
	КонецЦикла;
		
	// 11. Амортизация бухгалтерская.	
	СуммаАмортизацияОСБУ = 0;
	Если НЕ МассивРезультатовЗапроса[4].Пустой() Тогда 
		ВыборкаДетальныхЗаписей = МассивРезультатовЗапроса[4].Выбрать();
		ВыборкаДетальныхЗаписей.Следующий();
		СуммаАмортизацияОСБУ = ВыборкаДетальныхЗаписей.Сумма;
	КонецЕсли;	
	
	// 12. Амортизация налоговая.
	СуммаАмортизацияОСНУ = ДокументЗакрытиеМесяца.НалоговаяАмортизация.Итог("Амортизация");
	ПревышениеНормыНаРемонт = ДокументЗакрытиеМесяца.НалоговаяАмортизация.Итог("ПревышениеНормыНаРемонт");
	
	// 13. Прочие временные разницы.
	СуммаВременныеРазницы = 0;
	Если НЕ МассивРезультатовЗапроса[5].Пустой() Тогда 
		ВыборкаДетальныхЗаписей = МассивРезультатовЗапроса[5].Выбрать();
		Пока ВыборкаДетальныхЗаписей.Следующий() Цикл
			СтрокаНалоговойВыверки = Объект.НалоговаяВыверка13.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНалоговойВыверки, ВыборкаДетальныхЗаписей);
		КонецЦикла;		
	КонецЕсли;
	
	Если ПревышениеНормыНаРемонт > 0 Тогда
		СтрокаНалоговойВыверки = Объект.НалоговаяВыверка13.Добавить();
		СтрокаНалоговойВыверки.Документ = "Превышение нормы на ремонт";
	    СтрокаНалоговойВыверки.Сумма = ПревышениеНормыНаРемонт;
	КонецЕсли;
		
	// 14. Итого временные разницы.
	//СуммаИтогоВременныеРазницы = СуммаДоходОтВыбытияОС - СуммаАмортизацияОСБУ + СуммаАмортизацияОСНУ + СуммаВременныеРазницы;
		
КонецПроцедуры



#КонецОбласти




