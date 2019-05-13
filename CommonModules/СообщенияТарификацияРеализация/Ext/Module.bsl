﻿#Область СлужебныйПрограммныйИнтерфейс

// Обновляет общие (неразделенные) данные по тарифкации в БТС: 
//  - константа "Использовать контроль тарификации",
//  - справочник "Поставщики услуг",
//  - справочник "Услуги".
//
// Параметры:
//  ОбщиеДанныеПоТарификации - ОбъектXDTO - тело сообщения.
//
Процедура ОбновитьОбщиеДанныеПоТарификации(Знач ОбщиеДанныеПоТарификации) Экспорт
	
	НачатьТранзакцию();
	Попытка
		Если ОбщиеДанныеПоТарификации.UsingTariffControl <> Неопределено Тогда
			Тарификация.ОбновитьИспользованиеКонтроляТарификации(ОбщиеДанныеПоТарификации.UsingTariffControl);
		КонецЕсли;
		
		Для Каждого ПоставщикXDTO Из ОбщиеДанныеПоТарификации.ServiceProviders Цикл 
			Тарификация.ОбновитьПоставщикаУслуг(ПоставщикXDTO.Code, ПоставщикXDTO.Name, ПоставщикXDTO.ID, ПоставщикXDTO.DeletionMark);
		КонецЦикла;
		
		Для Каждого УслугаXDTO Из ОбщиеДанныеПоТарификации.Services Цикл 
			
			ПоставщикУслуги = Справочники.ПоставщикиУслугСервиса.НайтиПоРеквизиту("Идентификатор", УслугаXDTO.ServiceProviderID);
			Если ПоставщикУслуги.Пустая() Тогда 
				ВызватьИсключение НСтр("ru = 'Не найде поставщик услуги с кодом:'") + " " + УслугаXDTO.ServiceProviderID;
			КонецЕсли;
			
			ЗначенияРеквизитов = Тарификация.СоставРеквизитовУслуги();
			ЗначенияРеквизитов.Идентификатор = УслугаXDTO.ID;
			ЗначенияРеквизитов.Наименование = УслугаXDTO.Name;
			ЗначенияРеквизитов.ТипУслуги = Тарификация.ТипУслугиПоИдентификатору(УслугаXDTO.Type);
			ЗначенияРеквизитов.ПоставщикУслуги = ПоставщикУслуги;
			ЗначенияРеквизитов.Тарифицируется = УслугаXDTO.isTariffing;
			ЗначенияРеквизитов.ПометкаУдаления = УслугаXDTO.DeletionMark;
			ЗначенияРеквизитов.ПоказыватьПриДобавленииВТариф = УслугаXDTO.AvailableInTariff;
			
			Тарификация.ОбновитьУслугу(ЗначенияРеквизитов);
			
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Обновляет общие (неразделенные) данные по тарифкации в БТС: 
//  - константа "Использовать контроль тарификации",
//  - справочник "Поставщики услуг",
//  - справочник "Услуги".
//
// Параметры:
//  ДанныеАбонентаПоТарификации - ОбъектXDTO - тело сообщения.
//
Процедура ОбновитьДанныеАбонентаПоТарификацииВПриложении(Знач ДанныеАбонентаПоТарификации) Экспорт
	
	ИмяСобытия = ТарификацияСлужебный.ИмяСобытияТарификации() + НСтр("ru = 'Обновление данных по тарификации в области данных'");
	
	НачатьТранзакцию();
	Попытка
		
		Если ДанныеАбонентаПоТарификации.Overwrite Тогда
			Тарификация.ОчиститьДанныеАбонентаПоТарификацииВОбласти();
		КонецЕсли;
		
		МассивОчищенныхПодписок = Новый Массив;
		Для Каждого ПодпискаНаУслугу Из ДанныеАбонентаПоТарификации.ServiceSubscriptions Цикл
			
			Если МассивОчищенныхПодписок.Найти(ПодпискаНаУслугу.SubscriptionID) = Неопределено Тогда 
				Тарификация.УдалитьДанныеПоПодписке(ПодпискаНаУслугу.SubscriptionID);
				МассивОчищенныхПодписок.Добавить(ПодпискаНаУслугу.SubscriptionID);
			КонецЕсли;
			
			КоличествоДоступныхЛицензий = ?(ПодпискаНаУслугу.ПолучитьXDTO("AvailableLicenseCount") = Неопределено, 0, ПодпискаНаУслугу.AvailableLicenseCount);
			
			Услуга = Тарификация.УслугаПоИдентификаторуИИдентификаторуПоставщика(ПодпискаНаУслугу.ServiceID, ПодпискаНаУслугу.ServiceProviderID);
			Если Услуга <> Неопределено Тогда 
				Тарификация.СоздатьЗаписьДоступныеЛицензии(ПодпискаНаУслугу.SubscriptionID,
					Услуга,
					ПодпискаНаУслугу.SubscriptionBeginDate,
					ПодпискаНаУслугу.SubscriptionEndDate,
					ПодпискаНаУслугу.SubscriptionCode,
					КоличествоДоступныхЛицензий);
			Иначе
				ШаблонТекстаОшибки = НСтр("ru = 'Не найдена услуга с идентификатором ""%1"" и идентификатором поставщика ""%2""'");
				ТекстОшибки = СтрШаблон(ШаблонТекстаОшибки, ПодпискаНаУслугу.ServiceID, ПодпискаНаУслугу.ServiceProviderID);
				ЗаписьЖурналаРегистрации(ИмяСобытия, 
					УровеньЖурналаРегистрации.Ошибка,
					,
					,
					ТекстОшибки);
			КонецЕсли;
			
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(ИмяСобытия, 
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

// Удаляет подписки на услуги (разделенные данные) по абоненту.
//
// Параметры:
//  УдаляемыеПодписки - ОбъектXDTO - тело сообщения.
//
Процедура УдалитьДанныеПоТарификацииВПриложениеАбонента(Знач УдаляемыеПодписки) Экспорт
	
	Для Каждого Подписка Из УдаляемыеПодписки.SubscriptionsID Цикл
		НачатьТранзакцию();
		Попытка
			Тарификация.УдалитьДанныеПоПодписке(Подписка);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ИнформацияПоОшибке = НСтр("ru = 'Проблема с удалением данных по подписке:'") +
				" " +
				Строка(УдаляемыеПодписки.SubscriptionsID) +
				Символы.ПС +
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ИмяСобытия = ТарификацияСлужебный.ИмяСобытияТарификации() + НСтр("ru = 'Удаление данных по подписке'");
			ЗаписьЖурналаРегистрации(ИмяСобытия,
				УровеньЖурналаРегистрации.Ошибка,
				,
				,
				ИнформацияПоОшибке);
			ВызватьИсключение;
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

// Обновляет данные по лицензиям в РС "ЗанятыеЛицензии".
//
// Параметры:
//  ОбновляемыеЛицензии - ОбъектXDTO - тело сообщения.
//
Процедура ОбновитьДанныеПоЛицензиям(ОбновляемыеЛицензии) Экспорт
	
	НачатьТранзакцию();
	Попытка
		
		Если ОбновляемыеЛицензии.OverwriteInZone Тогда
			Тарификация.ОчиситьДанныеПоЛицензиям();
		КонецЕсли;
		
		Для Каждого ДанныеЛицензииXDTO Из ОбновляемыеЛицензии.Licences Цикл
			
			СтароеСостояниеЛицензии = "";
			
			Запись = ТарификацияСлужебный.ДобавитьЗанятуюЛицензию(ДанныеЛицензииXDTO, СтароеСостояниеЛицензии);
			
			ДанныеОЛицензии = Новый Структура("Услуга, ИмяЛицензии, КонтекстЛицензии");
			ЗаполнитьЗначенияСвойств(ДанныеОЛицензии, Запись);
			ДанныеОЛицензии.ИмяЛицензии = Запись.ИдентификаторЛицензии;
			
			Если СтароеСостояниеЛицензии <> ДанныеЛицензииXDTO.SubscriptionCode Тогда
				ТарификацияСлужебный.ПриИзмененииСостоянияАктивацииЛицензии(ДанныеОЛицензии, СтароеСостояниеЛицензии, ДанныеЛицензииXDTO.SubscriptionCode);
			КонецЕсли;
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ИнформацияПоОшибке = ИнформацияОбОшибке();
			ИмяСобытия = ТарификацияСлужебный.ИмяСобытияТарификации() + НСтр("ru = 'Обновление данных по лицензиям'");
			ЗаписьЖурналаРегистрации(ИмяСобытия,
				УровеньЖурналаРегистрации.Ошибка,
				,
				,
				ИнформацияПоОшибке);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Обновляет данные по лицензиям в РС "ЗанятыеЛицензии".
//
// Параметры:
//  УдаляемыеЛицензии - ОбъектXDTO - тело сообщения.
//
Процедура УдалитьДанныеПоЛицензиям(УдаляемыеЛицензии) Экспорт
	
	НачатьТранзакцию();
	Попытка
	
		Для Каждого ДанныеЛицензии Из УдаляемыеЛицензии.Licences Цикл
			
			ТарификацияСлужебный.УдалитьЗанятуюЛицензию(ДанныеЛицензии);
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ИнформацияПоОшибке = ИнформацияОбОшибке();
			ИмяСобытия = ТарификацияСлужебный.ИмяСобытияТарификации() + НСтр("ru = 'Удаление данных по лицензиям'");
			ЗаписьЖурналаРегистрации(ИмяСобытия,
				УровеньЖурналаРегистрации.Ошибка,
				,
				,
				ИнформацияПоОшибке);
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти



