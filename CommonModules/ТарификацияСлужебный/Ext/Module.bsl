﻿
#Область ПрограммныйИнтерфейс

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Если Не ИнтеграцияПодсистемБТС.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	Обработчик                     = Обработчики.Добавить();
	Обработчик.Версия              = "*";
	Обработчик.МонопольныйРежим    = Ложь;
	Обработчик.ОбщиеДанные         = Истина;
	Обработчик.РежимВыполнения     = "Оперативно";
	Обработчик.Процедура           = "ТарификацияСлужебный.ЗарегистрироватьТарифицируемыеУслуги_ОбработчикОбновления";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик                     = Обработчики.Добавить();
	Обработчик.Версия              = "1.0.10.51";
	Обработчик.МонопольныйРежим    = Ложь;
	Обработчик.ОбщиеДанные         = Истина;
	Обработчик.РежимВыполнения     = "Оперативно";
	Обработчик.Процедура           = "ТарификацияСлужебный.ЗапроситьЛицензииУникальныхУслуг_ОбработчикОбновления";
	Обработчик.НачальноеЗаполнение = Истина;
	
КонецПроцедуры

// См. ИнтерфейсыСообщенийВМоделиСервисаПереопределяемый.ЗаполнитьОбработчикиОтправляемыхСообщений.
Процедура РегистрацияИнтерфейсовОтправляемыхСообщений(МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияТарификацияИнтерфейс);
	
КонецПроцедуры

// См. ИнтерфейсыСообщенийВМоделиСервисаПереопределяемый.ЗаполнитьОбработчикиПринимаемыхСообщений.
Процедура РегистрацияИнтерфейсовПринимаемыхСообщений(МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияТарификацияИнтерфейс);
	
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.РегистрыСведений.ДоступныеЛицензии);
	Типы.Добавить(Метаданные.РегистрыСведений.ЗанятыеЛицензии);
	Типы.Добавить(Метаданные.Справочники.УслугиСервиса);
	Типы.Добавить(Метаданные.Справочники.ПоставщикиУслугСервиса);
	Типы.Добавить(Метаданные.Константы.ИспользоватьКонтрольТарификации);
	
КонецПроцедуры

// См. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий.
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.РегистрацияУслугСервиса;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ЗапросЛицензийУникальныхУслуг;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
КонецПроцедуры

// Возвращает поддерживает ли Менеджер сервиса управление тарифами в приложениях версии 1.0.1.2.
//
// Возвращаемое значение:
//  Булево - Истина, если поддерживает, Ложь - иначе.
//
Функция МенеджерСервисаПоддерживаетУправлениеТарифамиВПриложении_1_0_1_2() Экспорт
	
	Попытка
		УстановитьПривилегированныйРежим(Истина);
		ПараметрыПодключенияКМС = ПараметрыПодключенияКМенеджеруСервиса();
		ВерсииМС = ОбщегоНазначения.ПолучитьВерсииИнтерфейса(ПараметрыПодключенияКМС, "ApplicationTariffControl");
		УстановитьПривилегированныйРежим(Ложь);
		Если ВерсииМС = Неопределено Тогда
			Возврат Ложь;
		Иначе
			Возврат (ВерсииМС.Найти("1.0.1.2") <> Неопределено);
		КонецЕсли;
	Исключение
		ИмяСобытия = ИмяСобытияТарификации() + НСтр("ru = 'МенеджерСервисаПоддерживаетУправлениеТарифамиВПриложении_1_0_1_2'", КодЯзыка());
		ЗаписьЖурналаРегистрации(ИмяСобытия,
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

Функция ДобавитьЗанятуюЛицензию(Знач ДанныеОЛицензии, СтароеСостояниеЛицензии = "") Экспорт
	
	Услуга = Тарификация.УслугаПоИдентификаторуИИдентификаторуПоставщика(ДанныеОЛицензии.ServiceID,
		ДанныеОЛицензии.ServiceProviderID, Истина);
	
	Запись = РегистрыСведений.ЗанятыеЛицензии.СоздатьМенеджерЗаписи();
	Запись.Услуга = Услуга;
	Запись.ИдентификаторЛицензии = ДанныеОЛицензии.ID;
	Запись.КонтекстЛицензии = ДанныеОЛицензии.LicenseContext;
	Запись.Прочитать();
	Если Запись.Выбран() Тогда
		СтароеСостояниеЛицензии = Запись.НомерПодписки;
	Иначе
		Запись.Услуга = Услуга;
		Запись.ИдентификаторЛицензии = ДанныеОЛицензии.ID;
		Запись.КонтекстЛицензии = ДанныеОЛицензии.LicenseContext;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеОЛицензии.SubscriptionEndDate) = Тип("Строка") Тогда
		 ДатаОтключенияПодписки = XMLЗначение(Тип("Дата") ,ДанныеОЛицензии.SubscriptionEndDate);
	ИначеЕсли ТипЗнч(ДанныеОЛицензии.SubscriptionEndDate) = Тип("Дата") Тогда
		 ДатаОтключенияПодписки = ДанныеОЛицензии.SubscriptionEndDate;
	Иначе
		ДатаОтключенияПодписки = Неопределено;
	КонецЕсли;
	
	Запись.НомерПодписки = ДанныеОЛицензии.SubscriptionCode;
	Запись.ДатаОтключенияПодписки = ДатаОтключенияПодписки;
	Запись.ДатаИзменения = ТекущаяДатаСеанса();
	УстановитьПривилегированныйРежим(Истина);
	Запись.Записать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Запись;
	
КонецФункции

Процедура УдалитьЗанятуюЛицензию(Знач ДанныеОЛицензии) Экспорт
	
	Услуга = Тарификация.УслугаПоИдентификаторуИИдентификаторуПоставщика(ДанныеОЛицензии.ServiceID,
		ДанныеОЛицензии.ServiceProviderID);
	
	Набор = РегистрыСведений.ЗанятыеЛицензии.СоздатьНаборЗаписей();
	Набор.Отбор.Услуга.Установить(Услуга);
	Набор.Отбор.ИдентификаторЛицензии.Установить(ДанныеОЛицензии.ID);
	Набор.Отбор.КонтекстЛицензии.Установить(ДанныеОЛицензии.LicenseContext);
	УстановитьПривилегированныйРежим(Истина);
	Набор.Записать();
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

// Имя события для журнала регистрации.
//
// Возвращаемое значение:
//  Строка - имя события для ЖР.
//
Функция ИмяСобытияТарификации() Экспорт
	
	Возврат НСтр("ru = 'Управление тарифами в модели сервиса.'", КодЯзыка());
	
КонецФункции

// Событие, возникающее при изменении значения РС "ЗанятыеЛицензии".
//
// Параметры:
//  ДанныеОЛицензии - Структура - данные о лицензии.
//  СтарыйНомерПодпискиЛицензии - Строка - старый номер подписки лицензии.
//  НовыйНомерПодпискиЛицензии - Строка - новый номер подписки лицензии.
//
Процедура ПриИзмененииСостоянияАктивацииЛицензии(ДанныеОЛицензии, СтарыйНомерПодпискиЛицензии, НовыйНомерПодпискиЛицензии) Экспорт
	
	Если ПустаяСтрока(СтарыйНомерПодпискиЛицензии) И Не ПустаяСтрока(НовыйНомерПодпискиЛицензии) Тогда
		ТарификацияПереопределяемый.ПриИзмененииСостоянияАктивацииЛицензии(ДанныеОЛицензии, Истина);
	КонецЕсли;
	
	Если Не ПустаяСтрока(СтарыйНомерПодпискиЛицензии) И ПустаяСтрока(НовыйНомерПодпискиЛицензии) Тогда
		ТарификацияПереопределяемый.ПриИзмененииСостоянияАктивацииЛицензии(ДанныеОЛицензии, Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события "ПриУстановкеКонечнойТочкиМенеджераСервиса".
//
Процедура ПриУстановкеКонечнойТочкиМенеджераСервиса() Экспорт
	
	ЗарегистрироватьТарифицируемыеУслуги_ОбработчикОбновления();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиОбновления

// Регистрирует в МС тарифицируемые услуги, которые поддерживает данная конфигурация.
//
Процедура ЗарегистрироватьТарифицируемыеУслуги_ОбработчикОбновления() Экспорт
	
	ИмяСобытия = ИмяСобытияТарификации() + НСтр("ru = 'Регистрация тарифицируемых услуг.Обработчик обновления'", КодЯзыка());
	
	// Формирование списка услуг.
	ПоставщикиУслуг = СформироватьСписокПоставщиковУслуг();
	
	// Если конфигурация не содержит в себе услуг, то прекращаем действия.
	Если ПоставщикиУслуг.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	// Проверка правильности заполнения услуг и их поставщиков.
	ПроверитьСтруктуруПоставщиковУслуг(ПоставщикиУслуг);
	
	// Запись списка услуг в данные БТС.
	НачатьТранзакцию();
	Попытка
		ЗарегистрироватьТарифицируемыеУслугиВБТС(ПоставщикиУслуг);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ИнформацияПоОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение ИнформацияПоОшибке;
	КонецПопытки;
	
	СообщениеСформировано = Ложь;
	
	// Отправка списка услуг в Менеджер сервиса.
	НачатьТранзакцию();
	Попытка
		
		// Проверка того, что МС поддерживает тарификацию в БТС.
		Если Не МенеджерСервисаПоддерживаетТарификациюВБТС() Тогда
			РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
				Метаданные.РегламентныеЗадания.РегистрацияУслугСервиса, Истина);
			ЗафиксироватьТранзакцию();
			Возврат;
		КонецЕсли;
		
		ЗарегистрироватьТарифицируемыеУслугиВМенеджереСервиса(ПоставщикиУслуг);
		
		СообщениеСформировано = Истина;
		
		РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
			Метаданные.РегламентныеЗадания.РегистрацияУслугСервиса, Ложь);
		
		ТекстИнформации = НСтр("ru = 'Услуги успешно отправлены в Менеджер сервиса'");
		ЗаписьЖурналаРегистрации(ИмяСобытия, 
			УровеньЖурналаРегистрации.Информация,
			,
			,
			ТекстИнформации);
			
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		
		РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
			Метаданные.РегламентныеЗадания.РегистрацияУслугСервиса, Истина);
		
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИмяСобытия, 
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ТекстОшибки);
		
	КонецПопытки;
	
КонецПроцедуры

// Регистрирует в МС тарифицируемые услуги, которые поддерживает данная конфигурация.
//
Процедура ЗарегистрироватьТарифицируемыеУслуги_РегламентноеЗадание() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.РегистрацияУслугСервиса);
	
	ИмяСобытия = ИмяСобытияТарификации() + НСтр("ru = 'Регистрация тарифицируемых услуг.Регламентное задание'", КодЯзыка());
	
	// Формирование списка услуг.
	ПоставщикиУслуг = СформироватьСписокПоставщиковУслуг();
	
	// Если конфигурация не содержит в себе услуг, то прекращаем действия.
	Если ПоставщикиУслуг.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	СообщениеСформировано = Ложь;
	
	// Отправка услуг в Менеджер сервиса.
	НачатьТранзакцию();
	Попытка
		
		// Проверка того, что МС поддерживает тарификацию в БТС.
		Если Не МенеджерСервисаПоддерживаетТарификациюВБТС() Тогда
			ЗафиксироватьТранзакцию();
			Возврат;
		КонецЕсли;
		
		ЗарегистрироватьТарифицируемыеУслугиВМенеджереСервиса(ПоставщикиУслуг);
		
		СообщениеСформировано = Ложь;
		
		РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
			Метаданные.РегламентныеЗадания.РегистрацияУслугСервиса, Ложь);
			
		ТекстИнформации = НСтр("ru = 'Услуги успешно отправлены в Менеджер сервиса'");
		ЗаписьЖурналаРегистрации(ИмяСобытия, 
			УровеньЖурналаРегистрации.Информация,
			,
			,
			ТекстИнформации);
	
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИмяСобытия, 
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ТекстОшибки);
		
	КонецПопытки;
	
КонецПроцедуры

// Пытается запросить у Менеджера сервиса лицензии уникальных услуг.
//
// Параметры:
//  ВызыватьИсключение - Булево - вызывать исключение в коде.
//
Процедура ЗапроситьЛицензииУникальныхУслуг_ОбработчикОбновления(ВызыватьИсключение = Ложь) Экспорт
	
	РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.ЗапросЛицензийУникальныхУслуг, Истина);
	
КонецПроцедуры

// Пытается запросить у Менеджера сервиса лицензии уникальных услуг.
//
// Параметры:
//  ВызыватьИсключение - Булево - вызывать исключение в коде.
//
Процедура ЗапроситьЛицензииУникальныхУслуг_РегламентноеЗадание() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ЗапросЛицензийУникальныхУслуг);
	
	ИмяСобытия = ИмяСобытияТарификации() + НСтр("ru = 'Запрос лицензий уникальных услуг.Регламентное задание'", КодЯзыка());
	
	СообщениеСформировано = Ложь;
	
	НачатьТранзакцию();
	Попытка
		
		// Проверка того, что МС поддерживает тарификацию в БТС определенной версии.
		Если Не МенеджерСервисаПоддерживаетСообщенияТарификации_1_0_1_3() Тогда
			РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
				Метаданные.РегламентныеЗадания.ЗапросЛицензийУникальныхУслуг, Истина);
			ЗафиксироватьТранзакцию();
			Возврат;
		КонецЕсли;
		
		ЗапроситьЛицензииУникальныхУслугУМенеджераСервиса();
		
		СообщениеСформировано = Истина;
		
		РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
			Метаданные.РегламентныеЗадания.ЗапросЛицензийУникальныхУслуг, Ложь);
		
		ТекстИнформации = НСтр("ru = 'Успех.'");
		ЗаписьЖурналаРегистрации(ИмяСобытия, 
			УровеньЖурналаРегистрации.Информация,
			,
			,
			ТекстИнформации);
			
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		
		РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
			Метаданные.РегламентныеЗадания.ЗапросЛицензийУникальныхУслуг, Истина);
		
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИмяСобытия,
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ТекстОшибки);
		
	КонецПопытки;
	
	Если СообщениеСформировано Тогда 
		ОбменСообщениями.ДоставитьСообщения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнцидентыТарификации

// Возвращает имя инцидента, который означает, что что не найдена услуга по идентификатору и идентификатору поставщика.
Функция ТипИнцидента_НеНайденаУслугаПоИдентификаторуУслугиИИдентификаторуПоставщика() Экспорт
	
	Возврат "НеНайденаУслугаПоИдентификаторуУслугиИИдентификаторуПоставщика";
	
КонецФункции

#КонецОбласти

// Возвращает поддерживает ли Менеджер сервиса сообщения для управление тарифами версии 1.0.1.2.
//
// Возвращаемое значение:
//  Булево - Истина, если поддерживает, Ложь - иначе.
//
Функция МенеджерСервисаПоддерживаетТарификациюВБТС()
	
	ПараметрыПодключенияКМС = ПараметрыПодключенияКМенеджеруСервиса();
	ВерсииМС = ОбщегоНазначения.ПолучитьВерсииИнтерфейса(ПараметрыПодключенияКМС, "TariffApp");
	Если ВерсииМС = Неопределено Тогда
		Возврат Ложь;
	Иначе
		Возврат (ВерсииМС.Найти("1.0.1.2") <> Неопределено);
	КонецЕсли;
	
КонецФункции

// Возвращает поддерживает ли Менеджер сервиса сообщения для управление тарифами версии 1.0.1.3.
//
// Возвращаемое значение:
//  Булево - Истина, если поддерживает, Ложь - иначе.
//
Функция МенеджерСервисаПоддерживаетСообщенияТарификации_1_0_1_3()
	
	ПараметрыПодключенияКМС = ПараметрыПодключенияКМенеджеруСервиса();
	ВерсииМС = ОбщегоНазначения.ПолучитьВерсииИнтерфейса(ПараметрыПодключенияКМС, "TariffApp");
	Если ВерсииМС = Неопределено Тогда
		Возврат Ложь;
	Иначе
		Возврат (ВерсииМС.Найти("1.0.1.3") <> Неопределено);
	КонецЕсли;
	
КонецФункции

// Регистрирует услуги в Менеджере сервиса, которые в себе "несет" конфигурация.
//
// Параметры:
//  ПоставщикиУслуг - ОбъектXDTO - список поставщиков услуг и их услуг.
//
Процедура ЗарегистрироватьТарифицируемыеУслугиВМенеджереСервиса(Знач ПоставщикиУслуг)
	
	Сообщение = СформироватьСообщениеЗарегистрироватьТарифицируемыеУслуги(ПоставщикиУслуг);
	
	СообщенияВМоделиСервиса.ОтправитьСообщение(Сообщение, 
		РаботаВМоделиСервисаПовтИсп.КонечнаяТочкаМенеджераСервиса());
	
КонецПроцедуры

// Запрашивает у Менеджера сервиса лицензии уникальных услуг.
//
Процедура ЗапроситьЛицензииУникальныхУслугУМенеджераСервиса()
	
	Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
		СообщенияТарификацияИнтерфейс.ЗапроситьЛицензииУникальныхУслугУМенеджераСервиса());
	
	СообщенияВМоделиСервиса.ОтправитьСообщение(Сообщение, 
		РаботаВМоделиСервисаПовтИсп.КонечнаяТочкаМенеджераСервиса());
	
КонецПроцедуры

// Формируется сообщение в МС о том, чтобы зарегистрировать услуги, которые в себе "несет" конфигурация.
//
// Параметры:
//  ПоставщикиУслуг - Структура - список поставщиков услуг и их услуг.
//
// Возвращаемое значение:
//  ОбъектXDTO - сообщение системы.
//
Функция СформироватьСообщениеЗарегистрироватьТарифицируемыеУслуги(Знач ПоставщикиУслуг)
	
	Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
		СообщенияТарификацияИнтерфейс.ЗарегистрироватьТарифицируемыеУслуги());
		
	Сообщение.Body.ConfugurationVersion = Метаданные.Версия;
	Сообщение.Body.TariffVersion = СообщенияТарификацияИнтерфейс.Версия();
	
	Для Каждого Поставщик Из ПоставщикиУслуг Цикл
		
		ПоставщикXDTO = ФабрикаXDTO.Создать(СообщенияТарификацияИнтерфейс.ТипПоставщикаУслуги());
		ПоставщикXDTO.ID = Поставщик.Идентификатор;
		ПоставщикXDTO.Name = Поставщик.Наименование;
		ПоставщикXDTO.DeletionMark = Неопределено;
		ПоставщикXDTO.Code = Неопределено;
		
		Для Каждого Услуга Из Поставщик.Услуги Цикл
			
			УслугаXDTO = ФабрикаXDTO.Создать(СообщенияТарификацияИнтерфейс.ТипУслуги());
			УслугаXDTO.ID = Услуга.Идентификатор;
			УслугаXDTO.Name = Услуга.Наименование;
			УслугаXDTO.Type = Тарификация.СоответствиеТипаУслугиИЕеИдентификатора().Получить(Услуга.ТипУслуги);;
			УслугаXDTO.DeletionMark = Неопределено;
			УслугаXDTO.isTariffing = Неопределено;
			УслугаXDTO.ServiceProviderID = Неопределено;
			УслугаXDTO.AvailableInTariff = Неопределено;
			ПоставщикXDTO.Services.Добавить(УслугаXDTO);
			
		КонецЦикла;
		
		Сообщение.Body.ServiceProviders.Добавить(ПоставщикXDTO);
		
	КонецЦикла;
	
	Возврат Сообщение;
	
КонецФункции

// Проверяет то, что поставщики услуг заданы правильно прикладными разработчиками:
//  1. Проверяет то, что нет одинаковых идентификаторов у поставщиков услуг.
//
// Параметры:
//  ПоставщикиУслуг - Массив - массив поставщиков.
//
Процедура ПроверитьСтруктуруПоставщиковУслуг(ПоставщикиУслуг)
	
	МассивПроверенных = Новый Массив;
	
	Для Каждого Поставщик Из ПоставщикиУслуг Цикл
		Если МассивПроверенных.Найти(Поставщик.Идентификатор) = Неопределено Тогда 
			МассивПроверенных.Добавить(Поставщик.Идентификатор);
		Иначе
			ВызватьИсключение НСтр("ru = 'Имеется несколько поставщиков услуг с идентификатором:'") + " " + Поставщик.Идентификатор;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Регистрирует услуги в прикладной Информационной базе, которые в себе "несет" конфигурация.
//
// Параметры:
//  ПоставщикиУслуг - Структура - список поставщиков услуг и их услуг.
//
Процедура ЗарегистрироватьТарифицируемыеУслугиВБТС(ПоставщикиУслуг)
	
	Для Каждого Поставщик Из ПоставщикиУслуг Цикл
		
		ПоставщикСсылка = Справочники.ПоставщикиУслугСервиса.НайтиПоРеквизиту("Идентификатор", Поставщик.Идентификатор);
		Если Не ЗначениеЗаполнено(ПоставщикСсылка) Тогда 
			ПоставщикСсылка = Тарификация.ОбновитьПоставщикаУслуг(Неопределено, Поставщик.Наименование, Поставщик.Идентификатор, Ложь);
		КонецЕсли;
		
		Для Каждого Услуга Из Поставщик.Услуги Цикл 
			
			УслугаСсылка = Тарификация.УслугаПоИдентификаторуИИдентификаторуПоставщика(Услуга.Идентификатор, Поставщик.Идентификатор, Ложь);
			Если Не ЗначениеЗаполнено(УслугаСсылка) Тогда 
				ЗначенияРеквизитов = Тарификация.СоставРеквизитовУслуги();
				ЗначенияРеквизитов.Идентификатор = Услуга.Идентификатор;
				ЗначенияРеквизитов.Наименование = Услуга.Наименование;
				ЗначенияРеквизитов.ТипУслуги = Услуга.ТипУслуги;
				ЗначенияРеквизитов.ПоставщикУслуги = ПоставщикСсылка;
				ЗначенияРеквизитов.Тарифицируется = Ложь;
				ЗначенияРеквизитов.ПометкаУдаления = Ложь;
				ЗначенияРеквизитов.ПоказыватьПриДобавленииВТариф = Ложь;
				
				Тарификация.ОбновитьУслугу(ЗначенияРеквизитов);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает массив поставщиков с их услугами.
//
// Возвращаемое значение:
//  Массив - массив поставщиков услуг.
//
Функция СформироватьСписокПоставщиковУслуг()
	
	ПоставщикиУслуг = Новый Массив;
	
	ИнтеграцияПодсистемБТС.ПриФормированииСпискаУслуг(ПоставщикиУслуг);
	ТарификацияПереопределяемый.ПриФормированииСпискаУслуг(ПоставщикиУслуг);
	
	Возврат ПоставщикиУслуг;
	
КонецФункции

// Параметры подключения к Менеджеру сервиса.
//
// Возвращаемое значение:
//  Структура - параметры подключения к Менеджеру сервиса.
//
Функция ПараметрыПодключенияКМенеджеруСервиса()
	
	ВерсияБСП301 = ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СтандартныеПодсистемыСервер.ВерсияБиблиотеки(), "3.0.1.1") >= 0;
	Если ВерсияБСП301 Тогда
		МодульНастройкиТранспорта = РегистрыСведений["НастройкиТранспортаОбменаСообщениями"];
	Иначе
		МодульНастройкиТранспорта = РегистрыСведений["НастройкиТранспортаОбмена"];
	КонецЕсли;
	
	СтруктураНастроек = МодульНастройкиТранспорта.НастройкиТранспортаWS(
		РаботаВМоделиСервисаПовтИсп.КонечнаяТочкаМенеджераСервиса());
		
	ПараметрыПодключенияКМС = Новый Структура;
	ПараметрыПодключенияКМС.Вставить("URL",      СтруктураНастроек.WSURLВебСервиса);
	ПараметрыПодключенияКМС.Вставить("UserName", СтруктураНастроек.WSИмяПользователя);
	ПараметрыПодключенияКМС.Вставить("Password", СтруктураНастроек.WSПароль);
	
	Возврат ПараметрыПодключенияКМС;
	
КонецФункции

// Возвращает код языка.
//
// Возвращаемое значение:
//  Строка - код языка.
//
Функция КодЯзыка()
	
	Возврат ОбщегоНазначения.КодОсновногоЯзыка();
	
КонецФункции

#КонецОбласти
