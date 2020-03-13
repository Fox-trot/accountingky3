﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// См. ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы.
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователейКлиент.ПриНачалеРаботыСистемы(Параметры);
	// Конец ИнтернетПоддержкаПользователей
	
	// НачалоРаботыСПрограммой
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		
		Если ПараметрыРаботыКлиента.ПоказатьОкноНачалоРаботыСПрограммой Тогда
			
			ПараметрыНачалаРаботы = Новый Структура("ПараметрыРаботыКлиента, ОткрытьФорму", ПараметрыРаботыКлиента, Ложь);
			НачалоРаботыСПрограммойКлиент.ИнтерфейсНачалоРаботы(ПараметрыНачалаРаботы);
			
		КонецЕсли;
		
		//ОбновитьИнтерфейс();
	КонецЕсли;
	// Конец НачалоРаботыСПрограммой
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
Процедура ПослеНачалаРаботыСистемы() Экспорт
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();

	// ЗнакомствоСРедакциейВ30
	Если ПараметрыРаботыКлиента.Свойство("ПоказатьЗнакомствоСРедакциейВ30")
		И ПараметрыРаботыКлиента.ПоказатьЗнакомствоСРедакциейВ30 Тогда
		ОбщегоНазначенияБПКлиент.ОткрытьНачинаемРаботатьВ30(ПараметрыРаботыКлиента.ИмяОбработкиЗнакомствоСРедакциейВ30);
	КонецЕсли;	
	// Конец ЗнакомствоСРедакциейВ30
	
	// ПечатьПараметровУчета
	Если ПараметрыРаботыКлиента.Свойство("ПоказатьПечатьПараметровУчета")
		И ПараметрыРаботыКлиента.ПоказатьПечатьПараметровУчета Тогда
		ОбщегоНазначенияБПКлиент.ОткрытьПечатьПараметровУчета(ПараметрыРаботыКлиента.ИмяОбработкиПечатьПараметровУчета);
	КонецЕсли;	
	// Конец ПечатьПараметровУчета

	Если ПараметрыРаботыКлиента.Свойство("ПоказатьПредложитьОбновитьВерсиюПрограммы") 
		И ПараметрыРаботыКлиента.ПоказатьПредложитьОбновитьВерсиюПрограммы Тогда
		// Информация о необходимости обновить конфигурацию
		ОбщегоНазначенияБПКлиент.ПредупредитьОНеобходимостиОбновленияПрограммы(ПараметрыРаботыКлиента);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
