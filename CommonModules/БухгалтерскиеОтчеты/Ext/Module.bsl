﻿////////////////////////////////////////////////////////////////////////////////
// Функции и процедуры обеспечения формирования бухгалтерских отчетов.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Процедура ОбработатьНаборДанныхСвязаннойИнформации(Схема, ИмяНабора, ПараметрыПоляВладельца, ИмяПоляПрефикс = "Субконто") Экспорт
	
	Если ПараметрыПоляВладельца.ИндексСубконто > 0 Тогда
		ПутьКДаннымОсновногоПоля = "";
		ЗаголовокОсновногоПоля   = "";
		Для Каждого ПолеНабора Из Схема.НаборыДанных[ИмяНабора].Поля Цикл
			Если Найти(ПолеНабора.Поле, "СвязанноеПолеСсылка") = 1 Тогда
				ПутьКДаннымОсновногоПоля = ПолеНабора.ПутьКДанным;
				ЗаголовокОсновногоПоля   = СтрЗаменить(ПолеНабора.Заголовок, ".Ссылка", "");
			КонецЕсли;
		КонецЦикла;
		Для Каждого ПолеНабора Из Схема.НаборыДанных[ИмяНабора].Поля Цикл
			Если Найти(ПолеНабора.Поле, "СвязанноеПоле") = 1 Тогда
				ПолеНабора.ПутьКДанным = СтрЗаменить(ПолеНабора.ПутьКДанным, ПутьКДаннымОсновногоПоля, ИмяПоляПрефикс + ПараметрыПоляВладельца.ИндексСубконто);
				ПолеНабора.Заголовок   = СтрЗаменить(ПолеНабора.Заголовок, ЗаголовокОсновногоПоля, ПараметрыПоляВладельца.ЗаголовокСубконто);
				ПолеНабора.ОграничениеИспользования.Группировка = Истина;
				ПолеНабора.ОграничениеИспользования.Поле        = Ложь;
				ПолеНабора.ОграничениеИспользования.Условие     = Истина;
				ПолеНабора.ОграничениеИспользования.Порядок     = Ложь;
			КонецЕсли;
		КонецЦикла;
		Для Каждого Связь Из Схема.СвязиНаборовДанных Цикл
			Если Связь.НаборДанныхПриемник = ИмяНабора Тогда
				Связь.ВыражениеИсточник = ИмяПоляПрефикс + ПараметрыПоляВладельца.ИндексСубконто;
				Связь.ВыражениеПриемник = ИмяПоляПрефикс + ПараметрыПоляВладельца.ИндексСубконто;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Для Каждого ПолеНабора Из Схема.НаборыДанных[ИмяНабора].Поля Цикл
			Если Найти(ПолеНабора.Поле, "СвязанноеПоле") = 1 Тогда
				ПолеНабора.ОграничениеИспользования.Группировка = Истина;
				ПолеНабора.ОграничениеИспользования.Поле        = Истина;
				ПолеНабора.ОграничениеИспользования.Условие     = Истина;
				ПолеНабора.ОграничениеИспользования.Порядок     = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// ДобавитьОтборПоОрганизациямИПодразделениям
Функция ДобавитьОтборПоОрганизациям(ЭлементСтруктуры, ПараметрыОтчета, Использование = Истина, ДтКт = Ложь) Экспорт
	
	ПолеОрганизация 	= Новый ПолеКомпоновкиДанных("Организация");
	
	Если ТипЗнч(ЭлементСтруктуры) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Настройки.Отбор;
	Иначе
		Отбор = ЭлементСтруктуры;
	КонецЕсли;
	
	НоваяГруппаИли = Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	НоваяГруппаИли.Использование  	= Использование;
	НоваяГруппаИли.ТипГруппы 		= ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	НоваяГруппаИли.Представление 	= "###ОтборПоОрганизации###";
	
	ИспользованиеОграничения = Ложь;
	
	СписокСтруктурныхЕдиниц = ?(ПараметрыОтчета.Свойство("СписокСтруктурныхЕдиниц"), ПараметрыОтчета.СписокСтруктурныхЕдиниц, Новый СписокЗначений);
		
	Для Каждого ТекОрганизация Из СписокСтруктурныхЕдиниц Цикл 
		
		НоваяГруппаИ = НоваяГруппаИли.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		НоваяГруппаИ.Использование  = Использование;
		НоваяГруппаИ.ТипГруппы 		= ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
		
		НовыйЭлемент = НоваяГруппаИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйЭлемент.Использование  = Использование;
		НовыйЭлемент.ЛевоеЗначение 	= ПолеОрганизация;
		НовыйЭлемент.ВидСравнения 	= ВидСравненияКомпоновкиДанных.Равно;
		НовыйЭлемент.ПравоеЗначение = ТекОрганизация.Значение;
	КонецЦикла;	
	
	Возврат НовыйЭлемент;	
		
КонецФункции

//Функция вернёт все доступные пользователю подразделения организации
//
Функция ПолучитьСписокДоступныхОрганизаций() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Организация,
	|	Организации.Наименование
	|ИЗ
	|	Справочник.Организации КАК Организации";
	
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Выгрузить();
	
КонецФункции

//Функция вернёт все доступные пользователю подразделения организации
//
Функция ПолучитьСписокДоступныхПодразделений(Организация = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ГруппыПользователейПользователиГруппы.Ссылка КАК ГруппаПользователей
	               |ПОМЕСТИТЬ ГруппыПользователя
	               |ИЗ
	               |	Справочник.ГруппыПользователей.Состав КАК ГруппыПользователейПользователиГруппы
	               |ГДЕ
	               |	ГруппыПользователейПользователиГруппы.Пользователь = &ТекущийПользователь
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	               |	НастройкиПравДоступаПользователей.ОбъектДоступа КАК Подразделение
	               |ИЗ
	               |	РегистрСведений.НастройкиПравДоступаПользователей КАК НастройкиПравДоступаПользователей
	               |ГДЕ
	               |	НастройкиПравДоступаПользователей.ОбъектДоступа ССЫЛКА Справочник.ПодразделенияОрганизаций
	               |	И НастройкиПравДоступаПользователей.Пользователь В
	               |			(ВЫБРАТЬ
	               |				Группыпользователя.ГруппаПользователей
	               |			ИЗ
	               |				ГруппыПользователя КАК Группыпользователя)";
	
	Если ТипЗнч(Организация) = Тип("СписокЗначений") Тогда 
		Запрос.Текст = запрос.Текст + "		
		|	И НастройкиПравДоступаПользователей.ОбъектДоступа.Владелец В (&Организация)";
	ИначеЕсли ТипЗнч(Организация) = Тип("СправочникСсылка.Организации") Тогда
		Запрос.Текст = запрос.Текст + "				   
		|	И НастройкиПравДоступаПользователей.ОбъектДоступа.Владелец = &Организация";
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ТекущийПользователь", Пользователи.ТекущийПользователь());
	
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Выгрузить();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьПредставлениеПериода(ПараметрыОтчета, ТолькоДаты  = Ложь)
	
	ТекстПериод = "";
	
	Если ПараметрыОтчета.Свойство("НеДобавлятьПериод") И ПараметрыОтчета.НеДобавлятьПериод Тогда
		Возврат ТекстПериод;
	КонецЕсли; 
	
	Если ПараметрыОтчета.Свойство("Период") Тогда
		
		Если ЗначениеЗаполнено(ПараметрыОтчета.Период) Тогда
			ТекстПериод = ?(ТолькоДаты, "", " на ") + Формат(ПараметрыОтчета.Период, "ДЛФ=D");
		КонецЕсли;
		
	ИначеЕсли ПараметрыОтчета.Свойство("НачалоПериода")
		И ПараметрыОтчета.Свойство("КонецПериода") Тогда
		
		НачалоПериода = ПараметрыОтчета.НачалоПериода;
		КонецПериода  = ПараметрыОтчета.КонецПериода;
		
		Если ЗначениеЗаполнено(КонецПериода) Тогда 
			Если КонецПериода >= НачалоПериода Тогда
				ТекстПериод = ?(ТолькоДаты, "", " за ") + ПредставлениеПериода(НачалоДня(НачалоПериода), КонецДня(КонецПериода), "ФП = Истина");
			Иначе
				ТекстПериод = "";
			КонецЕсли;
		ИначеЕсли ЗначениеЗаполнено(НачалоПериода) И Не ЗначениеЗаполнено(КонецПериода) Тогда
			ТекстПериод = ?(ТолькоДаты, "", " за ") + ПредставлениеПериода(НачалоДня(НачалоПериода), КонецДня(Дата(3999, 11, 11)), "ФП = Истина");
			ТекстПериод = СтрЗаменить(ТекстПериод, Сред(ТекстПериод, СтрНайти(ТекстПериод, " - ")), " - ...");
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТекстПериод;
	
КонецФункции

Функция ПолучитьТекстЗаголовкаОтчета(ПараметрыОтчета)
	
	ТекстЗаголовка = ПараметрыОтчета.Заголовок + ПолучитьПредставлениеПериода(ПараметрыОтчета);
	Возврат ТекстЗаголовка;
	
КонецФункции

Функция ПолучитьЗначениеПериодичности(НачалоПериода, КонецПериода) Экспорт
	
	Результат = Перечисления.Периодичность.Месяц;
	Если ЗначениеЗаполнено(НачалоПериода)
		И ЗначениеЗаполнено(КонецПериода) Тогда
		
		Разность = КонецПериода - НачалоПериода;
		Если Разность / 86400 < 45 Тогда
			Результат = Перечисления.Периодичность.День;
		Иначе
			Результат = Перечисления.Периодичность.Месяц; // месяц
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ВывестиЗаголовокОтчета(ПараметрыОтчета, Результат) Экспорт
	
	ПараметрыВывода = ПараметрыОтчета.НастройкиОтчета.ПараметрыВывода;
	
	ВыводитьЗаголовок = Истина;
	ПараметрВывода = ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьЗаголовок"));
	Если ПараметрВывода <> Неопределено Тогда 
		Если ПараметрВывода.Использование 
			И ПараметрВывода.Значение = ТипВыводаТекстаКомпоновкиДанных.НеВыводить Тогда
			ВыводитьЗаголовок = Ложь;
		Иначе 
			ПараметрВывода.Использование = Истина;
			ПараметрВывода.Значение = ТипВыводаТекстаКомпоновкиДанных.НеВыводить; // отключаем стандартный вывод заголовка
		КонецЕсли;		
	КонецЕсли;
	
	ПараметрВывода = ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьПараметрыДанных"));
	Если ПараметрВывода <> Неопределено
		И (Не ПараметрВывода.Использование ИЛИ ПараметрВывода.Значение <> ТипВыводаТекстаКомпоновкиДанных.НеВыводить) Тогда
		ПараметрВывода.Использование = Истина;
		ПараметрВывода.Значение = ТипВыводаТекстаКомпоновкиДанных.НеВыводить; // отключаем стандартный вывод параметров
	КонецЕсли;
	
	ПараметрВывода = ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьОтбор"));
	Если ПараметрВывода <> Неопределено
		И (Не ПараметрВывода.Использование ИЛИ ПараметрВывода.Значение <> ТипВыводаТекстаКомпоновкиДанных.НеВыводить) Тогда
		ПараметрВывода.Использование = Истина;
		ПараметрВывода.Значение = ТипВыводаТекстаКомпоновкиДанных.НеВыводить; // отключаем стандартный вывод отбора
	КонецЕсли;
	
	Макет = ПолучитьОбщийМакет("ОбщиеОбластиСтандартногоОтчета");
	ОбластьОрганизация      = Макет.ПолучитьОбласть("Организация");
	ОбластьЗаголовок        = Макет.ПолучитьОбласть("ОбластьЗаголовок");
	ОбластьОписаниеНастроек = Макет.ПолучитьОбласть("ОписаниеНастроек");
	
	// Заголовок
	Если ВыводитьЗаголовок 
		И ЗначениеЗаполнено(ПараметрыОтчета.Заголовок) Тогда
		
		// Организация
		Если ПараметрыОтчета.Свойство("НастройкиОтчета") Тогда 
			Организация = БухгалтерскиеОтчетыКлиентСервер.НайтиЭлементОтбора(ПараметрыОтчета.НастройкиОтчета, "Организация", Истина);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Организация) Тогда   
			Организация = ?(ПараметрыОтчета.Свойство("Организация"), ПараметрыОтчета.Организация, Неопределено);
		КонецЕсли;
		
		ОбластьОрганизация.Параметры.НазваниеОрганизации = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьПолноеНаименованиеОрганизации(Организация);
		Результат.Вывести(ОбластьОрганизация);

		ОбластьЗаголовок.Параметры.ЗаголовокОтчета = ПолучитьТекстЗаголовкаОтчета(ПараметрыОтчета);
		Результат.Вывести(ОбластьЗаголовок);
		
		ПараметрВыводаОтбора = ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьОтбор"));
		Если ПараметрВывода <> Неопределено И (ПараметрВыводаОтбора.Использование и ПараметрВывода.Значение <> ТипВыводаТекстаКомпоновкиДанных.НеВыводить) Тогда 
			// Отбор
			ТекстОтбор = "";
			
			Если ПараметрыОтчета.Свойство("ПараметрыВключаемыеВТекстОтбора")
				И ТипЗнч(ПараметрыОтчета.ПараметрыВключаемыеВТекстОтбора) = Тип("Массив") Тогда
				
				Для Каждого Параметр Из ПараметрыОтчета.ПараметрыВключаемыеВТекстОтбора Цикл
					Если ТипЗнч(Параметр) <> Тип("ЗначениеПараметраНастроекКомпоновкиДанных")
						ИЛИ Не Параметр.Использование Тогда
						Продолжить;
					КонецЕсли;
					ТекстОтбор = ТекстОтбор + ?(ПустаяСтрока(ТекстОтбор), "", НСтр("ru = ' И '")) 
					+ СокрЛП(Параметр.ПредставлениеПользовательскойНастройки) + " Равно """ + СокрЛП(Параметр.Значение) + """";
					
				КонецЦикла;
			КонецЕсли;
			
			Для Каждого ЭлементОтбора Из ПараметрыОтчета.НастройкиОтчета.Отбор.Элементы Цикл
				Если ТипЗнч(ЭлементОтбора) <> Тип("ЭлементОтбораКомпоновкиДанных")
					ИЛИ Не ЭлементОтбора.Использование
					ИЛИ Не ЗначениеЗаполнено(ЭлементОтбора.ИдентификаторПользовательскойНастройки)
					ИЛИ ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
					Продолжить;
				КонецЕсли;
				ТекстОтбор = ТекстОтбор + ?(ПустаяСтрока(ТекстОтбор), "", НСтр("ru = ' И '")) 
				+ СокрЛП(ЭлементОтбора.ЛевоеЗначение) + " " + СокрЛП(ЭлементОтбора.ВидСравнения) + " """ + СокрЛП(ЭлементОтбора.ПравоеЗначение) + """";
			КонецЦикла;
			
			Если Не ПустаяСтрока(ТекстОтбор) Тогда
				ОбластьОписаниеНастроек.Параметры.ИмяНастроекОтчета      = НСтр("ru = 'Отбор:'");
				ОбластьОписаниеНастроек.Параметры.ОписаниеНастроекОтчета = ТекстОтбор;
				Результат.Вывести(ОбластьОписаниеНастроек);
			КонецЕсли;
		КонецЕсли;
		
		Результат.Область("R1:R" + Результат.ВысотаТаблицы).Имя = "Заголовок";
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыводПодписейОтчета(ПараметрыОтчета, Результат) Экспорт 
	
	ВыводитьПодписи = ?(ПараметрыОтчета.Свойство("ВыводитьПодписи"), ПараметрыОтчета.ВыводитьПодписи, Истина);
	
	Если НЕ ВыводитьПодписи Тогда 
		Возврат;
	КонецЕсли;	
	
	Макет = ПолучитьОбщийМакет("ОбщиеОбластиСтандартногоОтчета");
	
	Период = ?(ПараметрыОтчета.Свойство("КонецПериода"), ПараметрыОтчета.КонецПериода, ТекущаяДата());
	Организация = ?(ПараметрыОтчета.Свойство("Организация"), ПараметрыОтчета.Организация, БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяОрганизация"));
	
	// Ответственные лица
	ОтветственныеЛица = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизаций(Организация, Период);

	ОбъектОтчет = Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоРеквизиту("Имя", ПараметрыОтчета.ИдентификаторОтчета);
	
	// Настройки печати
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОтветственныеЛицаОрганизацийДляПечатиСрезПоследних.ОбъектОтчет,
		|	ОтветственныеЛицаОрганизацийДляПечатиСрезПоследних.ОтветственноеЛицо
		|ИЗ
		|	РегистрСведений.ОтветственныеЛицаОрганизацийДляПечати.СрезПоследних(&Период, ) КАК ОтветственныеЛицаОрганизацийДляПечатиСрезПоследних
		|ГДЕ
		|	ОтветственныеЛицаОрганизацийДляПечатиСрезПоследних.ОбъектОтчет = &ОбъектОтчет
		|
		|УПОРЯДОЧИТЬ ПО
		|	ОтветственныеЛицаОрганизацийДляПечатиСрезПоследних.РеквизитДопУпорядочивания";
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("ОбъектОтчет", ОбъектОтчет);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда 
		ОбластьМакета = Макет.ПолучитьОбласть("ПодписиОтветственныеЛица");

		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Если ВыборкаДетальныеЗаписи.ОтветственноеЛицо = ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.Руководитель") Тогда 
				ОбластьМакета.Параметры.ОтветственноеЛицо 			= ВыборкаДетальныеЗаписи.ОтветственноеЛицо;	
				ОбластьМакета.Параметры.РасшифровкаПодписи 			= ОтветственныеЛица.Руководитель;	
				ОбластьМакета.Параметры.ДолжностьОтветственногоЛица = ОтветственныеЛица.РуководительДолжность;
			ИначеЕсли ВыборкаДетальныеЗаписи.ОтветственноеЛицо = ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер") Тогда 
				ОбластьМакета.Параметры.ОтветственноеЛицо 			= ВыборкаДетальныеЗаписи.ОтветственноеЛицо;	
				ОбластьМакета.Параметры.РасшифровкаПодписи 			= ОтветственныеЛица.ГлавныйБухгалтер;	
				ОбластьМакета.Параметры.ДолжностьОтветственногоЛица = ОтветственныеЛица.ГлавныйБухгалтерДолжность;
			ИначеЕсли ВыборкаДетальныеЗаписи.ОтветственноеЛицо = ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.Кассир") Тогда 
				ОбластьМакета.Параметры.ОтветственноеЛицо 			= ВыборкаДетальныеЗаписи.ОтветственноеЛицо;	
				ОбластьМакета.Параметры.РасшифровкаПодписи 			= ОтветственныеЛица.Кассир;	
				ОбластьМакета.Параметры.ДолжностьОтветственногоЛица = ОтветственныеЛица.КассирДолжность;
			КонецЕсли;	
			
			Результат.Вывести(ОбластьМакета);
		КонецЦикла;
	КонецЕсли;	
	
	// Выводить место для штампа
	НастройкиОтчета = БухгалтерскиеОтчетыВызовСервераПовтИсп.ПолучитьНастройкиОтчета(ОбъектОтчет);
	
	Если НастройкиОтчета.ВыводитьМестоДляШтампа Тогда 
		ОбластьМакета = Макет.ПолучитьОбласть("МестоДляШтампа");
		Результат.Вывести(ОбластьМакета);
	КонецЕсли;	
	
КонецПроцедуры

// Процедура устанавливает формулу расчета и формат динамического периода.
//
// Параметры:
//		СхемаКомпоновкиДанных - СхемаКомпоновкиДанных - СКД отчета
//		КомпоновщикНастроек - НастройкиКомпоновкиДанных - настройки отчета
//
Процедура НастроитьДинамическийПериод(СхемаКомпоновкиДанных, ПараметрыОтчета, ДополнятьПериод = Ложь) Экспорт
	
	НастройкиОтчета = ПараметрыОтчета.НастройкиОтчета;
	
	ПолеПараметр = Новый ПараметрКомпоновкиДанных("Периодичность");
	ПараметрПериодичность = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(ПолеПараметр);
	
	Если ПараметрПериодичность <> Неопределено
		И ПараметрПериодичность.Использование Тогда
		
		Если Не ЗначениеЗаполнено(ПараметрПериодичность.Значение)
			ИЛИ ПараметрПериодичность.Значение = Перечисления.Периодичность.Авто Тогда
			ПараметрПериодичность.Значение = ПолучитьЗначениеПериодичности(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
		КонецЕсли;
		
		ИскомоеПоле = СхемаКомпоновкиДанных.ВычисляемыеПоля.Найти("ДинамическийПериод");
		Если ИскомоеПоле <> Неопределено Тогда
			СтрокаДлительностьПериода = ОбщегоНазначения.ИмяЗначенияПеречисления(ПараметрПериодичность.Значение);
			ИскомоеПоле.Выражение = "Период" + СтрокаДлительностьПериода;
			ИскомоеПоле.Заголовок = СтрокаДлительностьПериода;
			
			ПараметрОформленияФормат = ИскомоеПоле.Оформление.Элементы.Найти("Формат");
			ПараметрОформленияФормат.Значение = ФорматнаяСтрокаДинамическогоПериода(ПараметрПериодичность.Значение);
			ПараметрОформленияФормат.Использование = Истина;
			
			Если ДополнятьПериод
				И ПараметрыОтчета.Свойство("НачалоПериода")
				И ПараметрыОтчета.Свойство("КонецПериода") Тогда
				
				ДополнениеПериода = ТипДополненияПериодаКомпоновкиДанных[СтрокаДлительностьПериода];
				ПолеДинамическийПериод = Новый ПолеКомпоновкиДанных("ДинамическийПериод");
				Группировки = ПолучитьГруппировки(НастройкиОтчета);
				Для Каждого Группировка Из Группировки Цикл
					Если Группировка.Значение.ПоляГруппировки.Элементы.Количество() = 1
						И Группировка.Значение.ПоляГруппировки.Элементы[0].Поле = ПолеДинамическийПериод Тогда
						ГруппировкаДинамическийПериод = Группировка.Значение.ПоляГруппировки.Элементы[0];
						ГруппировкаДинамическийПериод.ТипДополнения = ДополнениеПериода;
						ГруппировкаДинамическийПериод.НачалоПериода = ПараметрыОтчета.НачалоПериода;
						ГруппировкаДинамическийПериод.КонецПериода = ПараметрыОтчета.КонецПериода;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ФорматнаяСтрокаДинамическогоПериода(Периодичность) Экспорт
	
	ФорматнаяСтрока = "";
	
	Если Периодичность = Перечисления.Периодичность.День Тогда
		ФорматнаяСтрока = "Л=ru; ДФ='dd.MM.yy'";
	ИначеЕсли Периодичность = Перечисления.Периодичность.Неделя Тогда
		ФорматнаяСтрока = "Л=ru; ДФ='dd.MM.yy'";
	ИначеЕсли Периодичность = Перечисления.Периодичность.Декада Тогда
		ФорматнаяСтрока = "Л=ru; ДФ='dd.MM.yy'";
	ИначеЕсли Периодичность = Перечисления.Периодичность.Месяц Тогда
		ФорматнаяСтрока = "Л=ru; ДФ='MMM yy'";
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
		ФорматнаяСтрока = "Л=ru; ДФ='q ""кв."" yy'";
	ИначеЕсли Периодичность = Перечисления.Периодичность.Полугодие Тогда
		ФорматнаяСтрока = "Л=ru; ДФ='ММ.yy'";
	ИначеЕсли Периодичность = Перечисления.Периодичность.Год Тогда
		ФорматнаяСтрока = "Л=ru; ДФ='yyyy'";
	КонецЕсли;
	
	Возврат ФорматнаяСтрока;
	
КонецФункции

Процедура ОбработатьДиаграммыОтчета(ПараметрыОтчета, ДокументРезультат) Экспорт
	
	Для Каждого Рисунок Из ДокументРезультат.Рисунки Цикл
		// Выводим надписи вертикально, если количество точек диаграмм больше 6
		Попытка
			Если ТипЗнч(Рисунок.Объект) = Тип("Диаграмма") Тогда
				
				Если ПараметрыОтчета.Свойство("ТипДиаграммы")
					И ПараметрыОтчета.ТипДиаграммы <> Неопределено
					И Рисунок.Объект.ТипДиаграммы <> ПараметрыОтчета.ТипДиаграммы Тогда
					Рисунок.Объект.ТипДиаграммы = ПараметрыОтчета.ТипДиаграммы;
				КонецЕсли;
				
				Рисунок.Объект.ОбластьПостроения.ВертикальныеМетки  = (Рисунок.Объект.Точки.Количество() > 6);
				Рисунок.Объект.ОбластьПостроения.ФорматШкалыЗначений = "ЧГ=3,0";
				
				Рисунок.Объект.ПоложениеПодписейШкалыЗначенийИзмерительнойДиаграммы = ПоложениеПодписейШкалыЗначенийИзмерительнойДиаграммы.НаШкале;
				Рисунок.Объект.ПодписиШкалыЗначенийИзмерительнойДиаграммыВдольШкалы = Истина;
				Рисунок.Объект.ТолщинаШкалыИзмерительнойДиаграммы                   = 3;
				Рисунок.Объект.ФорматЗначенийВПодписях                              = "ЧДЦ=2; ЧГ=3,0";
				
			КонецЕсли;
		Исключение
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

// Процедура устанавливает размер рисунка с диаграммой отчета.
//
Процедура УстановитьРазмерДиаграммыОтчета(Рисунок) Экспорт

	Рисунок.Объект.ОтображатьЗаголовок = Ложь;
	Рисунок.Объект.ОбластьЛегенды.Низ = 0.90;
	Рисунок.Высота = 95;
	Рисунок.Ширина = 145;

КонецПроцедуры

// Выполняет установку макета оформления для отчета.
//
// Параметры:
//	НастройкаКомпоновкиДанных - НастройкиКомпоновкиДанных - Настройки, которые будут использоваться для отчета. 
//
Процедура УстановитьМакетОформленияОтчета(НастройкаКомпоновкиДанных) Экспорт
	
	ПараметрМакетОформления = ПолучитьПараметрВывода(НастройкаКомпоновкиДанных, "МакетОформления");
	Если ПараметрМакетОформления <> Неопределено
		И ПараметрМакетОформления.Использование
		И ЗначениеЗаполнено(ПараметрМакетОформления.Значение) Тогда
		// В отчете выбран конкретный макет оформления, его не меняем.
		Возврат;
	КонецЕсли;
	
	МакетОформления = БухгалтерскиеОтчетыВызовСервераПовтИсп.ПолучитьИмяМакетаОформления();
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(НастройкаКомпоновкиДанных, "МакетОформления", МакетОформления);	
	
КонецПроцедуры

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ФункцииОтчетовКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Если Настройки.Печать.ОриентацияСтраницы = ОриентацияСтраницы.Портрет Тогда 
		Настройки.Печать.Вставить("ПолеСлева", 20);
	Иначе 
		Настройки.Печать.Вставить("ПолеСверху", 20);
	КонецЕсли;	
КонецПроцедуры

#Область НастройкиОтчетов

// Процедура включает родительские группировки в пользовательских настройках, если включена хоть одна дочерняя
//
// Параметры:
//		КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - настройки отчета
//		ПользовательскиеНастройкиМодифицированы - Булево - обязательный к установке признак модификации польз. настроек отчета
//
Процедура ИсправитьНастройкиГруппировок(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы) Экспорт
	ПользовательскиеНастройки = КомпоновщикНастроек.ПользовательскиеНастройки;
	Настройки = КомпоновщикНастроек.Настройки;
	
	Для Каждого ПользовательскаяНастройка Из ПользовательскиеНастройки.Элементы Цикл
		Если (ТипЗнч(ПользовательскаяНастройка) = Тип("ГруппировкаКомпоновкиДанных") 
			Или ТипЗнч(ПользовательскаяНастройка) = Тип("ГруппировкаТаблицыКомпоновкиДанных")
			Или ТипЗнч(ПользовательскаяНастройка) = Тип("ТаблицаКомпоновкиДанных"))
			И ПользовательскаяНастройка.Использование Тогда
			ИсправитьНастройкиРодительскойГруппировки(ПользовательскаяНастройка, ПользовательскиеНастройки, Настройки, ПользовательскиеНастройкиМодифицированы);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ИсправитьНастройкиРодительскойГруппировки(ПользовательскаяНастройка, ПользовательскиеНастройки, Настройки, ПользовательскиеНастройкиМодифицированы)
	ИдентификаторПользовательскойНастройки = ПользовательскаяНастройка.ИдентификаторПользовательскойНастройки;
	
	Если Не ПустаяСтрока(ИдентификаторПользовательскойНастройки) Тогда
		ОбъектНастройки = ПолучитьОбъектПоПользовательскомуИдентификатору(Настройки, ИдентификаторПользовательскойНастройки);
	Иначе
		ОбъектНастройки = ПользовательскаяНастройка;
	КонецЕсли;
	РодительОбъектаНастройки = ОбъектНастройки.Родитель;
	
	Если ТипЗнч(РодительОбъектаНастройки) = Тип("ГруппировкаКомпоновкиДанных") 
		Или ТипЗнч(РодительОбъектаНастройки) = Тип("ГруппировкаТаблицыКомпоновкиДанных")
		Или ТипЗнч(РодительОбъектаНастройки) = Тип("ТаблицаКомпоновкиДанных") Тогда
		
		ИдентификаторПользовательскойНастройкиРодителя = РодительОбъектаНастройки.ИдентификаторПользовательскойНастройки;
		
		Если Не ПустаяСтрока(ИдентификаторПользовательскойНастройкиРодителя) Тогда
			ПользовательскаяНастройкаРодитель = НайтиПользовательскуюНастройку(ПользовательскиеНастройки, ИдентификаторПользовательскойНастройкиРодителя);
			ПользовательскаяНастройкаРодитель.Использование = Истина;
			ПользовательскиеНастройкиМодифицированы = Истина;
			
			ИсправитьНастройкиРодительскойГруппировки(ПользовательскаяНастройкаРодитель, ПользовательскиеНастройки, Настройки, ПользовательскиеНастройкиМодифицированы);
		Иначе
			ИсправитьНастройкиРодительскойГруппировки(РодительОбъектаНастройки, ПользовательскиеНастройки, Настройки, ПользовательскиеНастройкиМодифицированы);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Возвращает список всех группировок компоновщика настроек
// 
// Параметры:
//		ЭлементСтруктуры - элемент структуры настройки СКД, настройка СКД или компоновщик настроек 
//		ПоказыватьГруппировкиТаблиц - признак добавления в список группировки колонок (по умолчанию Истина)
//
Функция ПолучитьГруппировки(ЭлементСтруктуры, ПоказыватьГруппировкиТаблиц = Истина) Экспорт
	
	СписокПолей = Новый СписокЗначений;
	Если ТипЗнч(ЭлементСтруктуры) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Структура = ЭлементСтруктуры.Настройки.Структура;
		ДобавитьГруппировки(Структура, СписокПолей);
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("НастройкиКомпоновкиДанных") Тогда
		Структура = ЭлементСтруктуры.Структура;
		ДобавитьГруппировки(Структура, СписокПолей);
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ТаблицаКомпоновкиДанных") Тогда
		ДобавитьГруппировки(ЭлементСтруктуры.Строки, СписокПолей);
		ДобавитьГруппировки(ЭлементСтруктуры.Колонки, СписокПолей);
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ДиаграммаКомпоновкиДанных") Тогда
		ДобавитьГруппировки(ЭлементСтруктуры.Серии, СписокПолей);
		ДобавитьГруппировки(ЭлементСтруктуры.Точки, СписокПолей);
	Иначе
		ДобавитьГруппировки(ЭлементСтруктуры.Структура, СписокПолей, ПоказыватьГруппировкиТаблиц);
	КонецЕсли;
	
	Возврат СписокПолей;
	
КонецФункции

// Добавляет вложенные группировки элемента структуры.
//
Процедура ДобавитьГруппировки(Структура, СписокГруппировок, ПоказыватьГруппировкиТаблиц = Истина)
	
	Для каждого ЭлементСтруктуры Из Структура Цикл
		Если ТипЗнч(ЭлементСтруктуры) = Тип("ТаблицаКомпоновкиДанных") Тогда
			ДобавитьГруппировки(ЭлементСтруктуры.Строки, СписокГруппировок);
			ДобавитьГруппировки(ЭлементСтруктуры.Колонки, СписокГруппировок);
		ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ДиаграммаКомпоновкиДанных") Тогда
			ДобавитьГруппировки(ЭлементСтруктуры.Серии, СписокГруппировок);
			ДобавитьГруппировки(ЭлементСтруктуры.Точки, СписокГруппировок);
		Иначе
			СписокГруппировок.Добавить(ЭлементСтруктуры);
			Если ПоказыватьГруппировкиТаблиц Тогда
				ДобавитьГруппировки(ЭлементСтруктуры.Структура, СписокГруппировок);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Находит общую настройку по идентификатору пользовательской настройки.
//
// Параметры:
//   Настройки - НастройкиКомпоновкиДанных - Коллекции настроек.
//   ИдентификаторПользовательскойНастройки - Строка -
//
Функция ПолучитьОбъектПоПользовательскомуИдентификатору(Настройки, ИдентификаторПользовательскойНастройки, Иерархия = Неопределено) Экспорт
	Если Иерархия <> Неопределено Тогда
		Иерархия.Добавить(Настройки);
	КонецЕсли;
	
	ТипНастройки = ТипЗнч(Настройки);
	
	Если ТипНастройки <> Тип("НастройкиКомпоновкиДанных") Тогда
		
		Если Настройки.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки Тогда
			
			Возврат Настройки;
			
		ИначеЕсли ТипНастройки = Тип("НастройкиВложенногоОбъектаКомпоновкиДанных") Тогда
			
			Возврат ПолучитьОбъектПоПользовательскомуИдентификатору(Настройки.Настройки, ИдентификаторПользовательскойНастройки, Иерархия);
			
		ИначеЕсли ТипНастройки = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных")
			ИЛИ ТипНастройки = Тип("КоллекцияЭлементовСтруктурыДиаграммыКомпоновкиДанных")
			ИЛИ ТипНастройки = Тип("КоллекцияЭлементовСтруктурыНастроекКомпоновкиДанных") Тогда
			
			Для Каждого ВложенныйЭлемент Из Настройки Цикл
				РезультатПоиска = ПолучитьОбъектПоПользовательскомуИдентификатору(ВложенныйЭлемент, ИдентификаторПользовательскойНастройки, Иерархия);
				Если РезультатПоиска <> Неопределено Тогда
					Возврат РезультатПоиска;
				КонецЕсли;
			КонецЦикла;
			
			Если Иерархия <> Неопределено Тогда
				Иерархия.Удалить(Иерархия.ВГраница());
			КонецЕсли;
			
			Возврат Неопределено;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Настройки.Выбор.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки Тогда
		Возврат Настройки.Выбор;
	ИначеЕсли Настройки.УсловноеОформление.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки Тогда
		Возврат Настройки.УсловноеОформление;
	КонецЕсли;
	
	Если ТипНастройки <> Тип("ТаблицаКомпоновкиДанных") И ТипНастройки <> Тип("ДиаграммаКомпоновкиДанных") Тогда
		Если Настройки.Отбор.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки Тогда
			Возврат Настройки.Отбор;
		ИначеЕсли Настройки.Порядок.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки Тогда
			Возврат Настройки.Порядок;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипНастройки = Тип("НастройкиКомпоновкиДанных") Тогда
		РезультатПоиска = НайтиЭлементНастройки(Настройки.ПараметрыДанных, ИдентификаторПользовательскойНастройки);
		Если РезультатПоиска <> Неопределено Тогда
			Возврат РезультатПоиска;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипНастройки <> Тип("ТаблицаКомпоновкиДанных") И ТипНастройки <> Тип("ДиаграммаКомпоновкиДанных") Тогда
		РезультатПоиска = НайтиЭлементНастройки(Настройки.Отбор, ИдентификаторПользовательскойНастройки);
		Если РезультатПоиска <> Неопределено Тогда
			Возврат РезультатПоиска;
		КонецЕсли;
	КонецЕсли;
	
	РезультатПоиска = НайтиЭлементНастройки(Настройки.УсловноеОформление, ИдентификаторПользовательскойНастройки);
	Если РезультатПоиска <> Неопределено Тогда
		Возврат РезультатПоиска;
	КонецЕсли;
	
	Если ТипНастройки = Тип("ТаблицаКомпоновкиДанных") Тогда
		
		РезультатПоиска = ПолучитьОбъектПоПользовательскомуИдентификатору(Настройки.Строки, ИдентификаторПользовательскойНастройки, Иерархия);
		Если РезультатПоиска <> Неопределено Тогда
			Возврат РезультатПоиска;
		КонецЕсли;
		
		РезультатПоиска = ПолучитьОбъектПоПользовательскомуИдентификатору(Настройки.Колонки, ИдентификаторПользовательскойНастройки, Иерархия);
		Если РезультатПоиска <> Неопределено Тогда
			Возврат РезультатПоиска;
		КонецЕсли;
		
	ИначеЕсли ТипНастройки = Тип("ДиаграммаКомпоновкиДанных") Тогда
		
		РезультатПоиска = ПолучитьОбъектПоПользовательскомуИдентификатору(Настройки.Точки, ИдентификаторПользовательскойНастройки, Иерархия);
		Если РезультатПоиска <> Неопределено Тогда
			Возврат РезультатПоиска;
		КонецЕсли;
		
		РезультатПоиска = ПолучитьОбъектПоПользовательскомуИдентификатору(Настройки.Серии, ИдентификаторПользовательскойНастройки, Иерархия);
		Если РезультатПоиска <> Неопределено Тогда
			Возврат РезультатПоиска;
		КонецЕсли;
		
	Иначе
		
		РезультатПоиска = ПолучитьОбъектПоПользовательскомуИдентификатору(Настройки.Структура, ИдентификаторПользовательскойНастройки, Иерархия);
		Если РезультатПоиска <> Неопределено Тогда
			Возврат РезультатПоиска;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Иерархия <> Неопределено Тогда
		Иерархия.Удалить(Иерархия.ВГраница());
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция НайтиЭлементНастройки(ЭлементНастройки, ИдентификаторПользовательскойНастройки)
	// Поиск элемента с заданным значением свойства ИдентификаторПользовательскойНастройки (ИПН).
	
	МассивГрупп = Новый Массив;
	МассивГрупп.Добавить(ЭлементНастройки.Элементы);
	
	Пока МассивГрупп.Количество() > 0 Цикл
		
		КоллекцияЭлементов = МассивГрупп.Получить(0);
		МассивГрупп.Удалить(0);
		
		Для Каждого ПодчиненныйЭлемент Из КоллекцияЭлементов Цикл
			Если ТипЗнч(ПодчиненныйЭлемент) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
				// Не содержит ИПН; Коллекция вложенных элементов не содержит ИПН.
			ИначеЕсли ТипЗнч(ПодчиненныйЭлемент) = Тип("ЗначениеПараметраКомпоновкиДанных") Тогда
				// Не содержит ИПН; Коллекция вложенных элементов может содержать ИПН.
				МассивГрупп.Добавить(ПодчиненныйЭлемент.ЗначенияВложенныхПараметров);
			ИначеЕсли ПодчиненныйЭлемент.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки Тогда
				// Найден нужный элемент.
				Возврат ПодчиненныйЭлемент;
			Иначе
				// Содержит ИПН; Коллекция вложенных элементов может содержать ИПН.
				Если ТипЗнч(ПодчиненныйЭлемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
					МассивГрупп.Добавить(ПодчиненныйЭлемент.Элементы);
				ИначеЕсли ТипЗнч(ПодчиненныйЭлемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
					МассивГрупп.Добавить(ПодчиненныйЭлемент.ЗначенияВложенныхПараметров);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

// Находит пользовательскую настройку по ее идентификатору.
//
// Параметры:
//   ПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных - Коллекция пользовательских настроек.
//   Идентификатор - Строка -
//
Функция НайтиПользовательскуюНастройку(ПользовательскиеНастройкиКД, Идентификатор) Экспорт
	Для Каждого ПользовательскаяНастройка Из ПользовательскиеНастройкиКД.Элементы Цикл
		Если ПользовательскаяНастройка.ИдентификаторПользовательскойНастройки = Идентификатор Тогда
			Возврат ПользовательскаяНастройка;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

// Получает параметр вывода компоновщика настроек или настройки СКД
//
// Параметры:
//		КомпоновщикНастроекГруппировка - компоновщик настроек или настройка/группировка СКД
//		ИмяПараметра - имя параметра СКД
//
Функция ПолучитьПараметрВывода(Настройка, ИмяПараметра) Экспорт
	
	МассивПараметров   = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяПараметра, ".");
	УровеньВложенности = МассивПараметров.Количество();
	
	Если УровеньВложенности > 1 Тогда
		ИмяПараметра = МассивПараметров[0];		
	КонецЕсли;
	
	Если ТипЗнч(Настройка) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		ЗначениеПараметра = Настройка.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	Иначе
		ЗначениеПараметра = Настройка.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	КонецЕсли;
	
	Если УровеньВложенности > 1 Тогда
		Для Индекс = 1 По УровеньВложенности - 1 Цикл
			ИмяПараметра = ИмяПараметра + "." + МассивПараметров[Индекс];
			ЗначениеПараметра = ЗначениеПараметра.ЗначенияВложенныхПараметров.Найти(ИмяПараметра); 
		КонецЦикла;
	КонецЕсли;
	
	Возврат ЗначениеПараметра;  
	
КонецФункции

// Устанавливает параметр вывода компоновщика настроек или настройки СКД
//
// Параметры:
//		КомпоновщикНастроекГруппировка - компоновщик настроек или настройка/группировка СКД
//		ИмяПараметра - имя параметра СКД
//		Значение - значение параметра вывода СКД
//		Использование - Признак использования параметра. По умолчанию всегда принимается равным истине.
//
Функция УстановитьПараметрВывода(Настройка, ИмяПараметра, Значение, Использование = Истина) Экспорт
	
	ЗначениеПараметра = ПолучитьПараметрВывода(Настройка, ИмяПараметра);
	
	Если ЗначениеПараметра <> Неопределено Тогда
		ЗначениеПараметра.Использование = Использование;
		ЗначениеПараметра.Значение      = Значение;
	КонецЕсли;
	
	Возврат ЗначениеПараметра;
	
КонецФункции

#КонецОбласти

